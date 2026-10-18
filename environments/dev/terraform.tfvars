subscription_id     = "191839a3-3fe2-4852-b995-88a675fc1f7f"
environment         = "dev"
resource_group_name = "rg-dev-axion"
location            = "eastus"

# Network
vnet_name     = "vnet-dev-axion"
address_space = ["10.10.0.0/16"]

# Subnets for 3-Tier Architecture & Services
subnets = {
  frontend = {
    name             = "snet-dev-frontend"
    address_prefixes = ["10.10.1.0/24"]
  }
  backend = {
    name             = "snet-dev-backend"
    address_prefixes = ["10.10.2.0/24"]
  }
  database = {
    name             = "snet-dev-database"
    address_prefixes = ["10.10.3.0/24"]
  }
}

# Public IP for Frontend VM
public_ips = {
  frontend = {
    name              = "pip-dev-frontend"
    allocation_method = "Static"
    sku               = "Standard"
  }
}

# Network Interfaces
nics = {
  frontend = {
    name          = "nic-dev-frontend"
    subnet_key    = "frontend"
    public_ip_key = "frontend"
  }
  backend = {
    name          = "nic-dev-backend"
    subnet_key    = "backend"
    public_ip_key = null
  }
  database = {
    name          = "nic-dev-database"
    subnet_key    = "database"
    public_ip_key = null
  }
}

# VM Credentials
vm_admin_username = "azureuser"
vm_admin_password = "Password@12345!"

# 3 Virtual Machines (Frontend, Backend, Database)
vms = {
  frontend = {
    name            = "vm-dev-frontend"
    vm_size         = "Standard_B1s"
    nic_name        = "nic-dev-frontend"
    os_disk_type    = "Standard_LRS"
    os_disk_size_gb = 30
  }
  backend = {
    name            = "vm-dev-backend"
    vm_size         = "Standard_B1s"
    nic_name        = "nic-dev-backend"
    os_disk_type    = "Standard_LRS"
    os_disk_size_gb = 30
  }
  database = {
    name            = "vm-dev-database"
    vm_size         = "Standard_B2s"
    nic_name        = "nic-dev-database"
    os_disk_type    = "Standard_LRS"
    os_disk_size_gb = 32
  }
}

# ACR (Azure CAF Standard: cr<app><env><instance>)
acr_name = "craxiondev01"
acr_sku  = "Basic"

# AKS
aks_name         = "aks-dev-cluster"
aks_dns_prefix   = "aksdev"
aks_node_count   = 1
aks_node_vm_size = "Standard_B2s"

# PostgreSQL (Azure CAF Standard: psql-<app>-<env>-<instance>)
postgres_name          = "psql-axion-dev-01"
postgres_location      = "centralus"
db_admin_username      = "psqladmin"
db_admin_password      = "Axion#Dev2026!Pass"
postgres_sku_name      = "B_Standard_B1ms"
postgres_database_name = "axiondb"

tags = {
  Environment = "dev"
  Project     = "Axion-Platform"
  ManagedBy   = "Terraform"
}
