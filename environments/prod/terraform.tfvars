subscription_id     = "191839a3-3fe2-4852-b995-88a675fc1f7f"
environment         = "prod"
resource_group_name = "rg-prod-axion"
location            = "eastus"

# Network
vnet_name     = "vnet-prod-axion"
address_space = ["10.30.0.0/16"]

# Subnets for 3-Tier Architecture & Services
subnets = {
  frontend = {
    name             = "snet-prod-frontend"
    address_prefixes = ["10.30.1.0/24"]
  }
  backend = {
    name             = "snet-prod-backend"
    address_prefixes = ["10.30.2.0/24"]
  }
  database = {
    name             = "snet-prod-database"
    address_prefixes = ["10.30.3.0/24"]
  }
}

# Public IP for Frontend VM
public_ips = {
  frontend = {
    name              = "pip-prod-frontend"
    allocation_method = "Static"
    sku               = "Standard"
  }
}

# Network Interfaces
nics = {
  frontend = {
    name          = "nic-prod-frontend"
    subnet_key    = "frontend"
    public_ip_key = "frontend"
  }
  backend = {
    name          = "nic-prod-backend"
    subnet_key    = "backend"
    public_ip_key = null
  }
  database = {
    name          = "nic-prod-database"
    subnet_key    = "database"
    public_ip_key = null
  }
}

# VM Credentials
vm_admin_username = "azureuser"
vm_admin_password = "Password@Prod12345!"

# 3 Virtual Machines (Frontend, Backend, Database)
vms = {
  frontend = {
    name            = "vm-prod-frontend"
    vm_size         = "Standard_D2s_v5"
    nic_name        = "nic-prod-frontend"
    os_disk_type    = "Premium_LRS"
    os_disk_size_gb = 64
  }
  backend = {
    name            = "vm-prod-backend"
    vm_size         = "Standard_D4s_v5"
    nic_name        = "nic-prod-backend"
    os_disk_type    = "Premium_LRS"
    os_disk_size_gb = 64
  }
  database = {
    name            = "vm-prod-database"
    vm_size         = "Standard_E4s_v5"
    nic_name        = "nic-prod-database"
    os_disk_type    = "Premium_LRS"
    os_disk_size_gb = 128
  }
}

# ACR (Azure CAF Standard: cr<app><env><instance>)
acr_name = "craxionprod01"
acr_sku  = "Premium"

# AKS
aks_name         = "aks-prod-cluster"
aks_dns_prefix   = "aksprod"
aks_node_count   = 3
aks_node_vm_size = "Standard_D4s_v5"

# PostgreSQL (Azure CAF Standard: psql-<app>-<env>-<instance>)
postgres_name          = "psql-axion-prod-01"
postgres_location      = "centralus"
db_admin_username      = "psqladmin"
db_admin_password      = "Axion#Prod2026!Pass"
postgres_sku_name      = "GP_Standard_D2s_v3"
postgres_database_name = "axiondb"

tags = {
  Environment = "prod"
  Project     = "Axion-Platform"
  ManagedBy   = "Terraform"
}
