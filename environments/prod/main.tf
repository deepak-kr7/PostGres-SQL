# 1. Resource Group
module "resource_group" {
  source   = "../../modules/resource_group"
  name     = var.resource_group_name
  location = var.location
  tags     = var.tags
}

# 2. Virtual Network
module "virtual_network" {
  source              = "../../modules/virtual_network"
  name                = var.vnet_name
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  address_space       = var.address_space
  tags                = var.tags
}

# 3. Subnets (Frontend, Backend, Database)
module "subnet" {
  source               = "../../modules/subnet"
  resource_group_name  = module.resource_group.name
  virtual_network_name = module.virtual_network.name
  subnets              = var.subnets
}

# 4. Public IP (Frontend VM)
module "public_ip" {
  source              = "../../modules/public_ip"
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  public_ips          = var.public_ips
  tags                = var.tags
}

# 5. Network Interfaces
module "network_interface" {
  source              = "../../modules/network_interface"
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  nics = {
    for k, v in var.nics : k => {
      name         = v.name
      subnet_id    = module.subnet.subnet_ids[v.subnet_key]
      public_ip_id = v.public_ip_key != null ? module.public_ip.public_ip_ids[v.public_ip_key] : null
    }
  }
  tags = var.tags
}

# 6. 3-Tier Linux Virtual Machines (Frontend, Backend, Database)
module "virtual_machine" {
  source                = "../../modules/virtual_machine"
  resource_group_name   = module.resource_group.name
  location              = module.resource_group.location
  network_interface_ids = module.network_interface.nic_ids
  admin_username        = var.vm_admin_username
  admin_password        = var.vm_admin_password
  vms                   = var.vms
  tags                  = var.tags
}

# 7. Azure Container Registry (ACR)
module "acr" {
  source              = "../../modules/acr"
  name                = var.acr_name
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  sku                 = var.acr_sku
  tags                = var.tags
}

# 8. Azure Kubernetes Service (AKS)
module "aks" {
  depends_on          = [module.resource_group, module.virtual_network]
  source              = "../../modules/aks"
  name                = var.aks_name
  resource_group_name = module.resource_group.name
  location            = module.resource_group.location
  dns_prefix          = var.aks_dns_prefix
  node_count          = var.aks_node_count
  node_vm_size        = var.aks_node_vm_size
  tags                = var.tags
}

# 9. PostgreSQL Flexible Server
module "postgres" {
  source                 = "../../modules/postgres"
  name                   = var.postgres_name
  resource_group_name    = module.resource_group.name
  location               = var.postgres_location
  db_admin_username      = var.db_admin_username
  db_admin_password      = var.db_admin_password
  sku_name               = var.postgres_sku_name
  database_name          = var.postgres_database_name
  tags                   = var.tags
}
