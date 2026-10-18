subscription_id     = "191839a3-3fe2-4852-b995-88a675fc1f7f"
environment         = "qa"
resource_group_name = "rg-qa-axion"
location            = "eastus"

# Network
vnet_name     = "vnet-qa-axion"
address_space = ["10.20.0.0/16"]

# Subnets for 3-Tier Architecture & Services
subnets = {
  frontend = {
    name             = "snet-qa-frontend"
    address_prefixes = ["10.20.1.0/24"]
  }
  backend = {
    name             = "snet-qa-backend"
    address_prefixes = ["10.20.2.0/24"]
  }
  database = {
    name             = "snet-qa-database"
    address_prefixes = ["10.20.3.0/24"]
  }
}

# Public IP for Frontend VM
public_ips = {
  frontend = {
    name              = "pip-qa-frontend"
    allocation_method = "Static"
    sku               = "Standard"
  }
}

# Network Interfaces
nics = {
  frontend = {
    name          = "nic-qa-frontend"
    subnet_key    = "frontend"
    public_ip_key = "frontend"
  }
  backend = {
    name          = "nic-qa-backend"
    subnet_key    = "backend"
    public_ip_key = null
  }
  database = {
    name          = "nic-qa-database"
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
    name            = "vm-qa-frontend"
    vm_size         = "Standard_B1ms"
    nic_name        = "nic-qa-frontend"
    os_disk_type    = "Standard_LRS"
    os_disk_size_gb = 30
  }
  backend = {
    name            = "vm-qa-backend"
    vm_size         = "Standard_B2s"
    nic_name        = "nic-qa-backend"
    os_disk_type    = "Standard_LRS"
    os_disk_size_gb = 30
  }
  database = {
    name            = "vm-qa-database"
    vm_size         = "Standard_B2ms"
    nic_name        = "nic-qa-database"
    os_disk_type    = "Premium_LRS"
    os_disk_size_gb = 64
  }
}

# ACR (Azure CAF Standard: cr<app><env><instance>)
acr_name = "craxionqa01"
acr_sku  = "Basic"

# AKS
aks_name         = "aks-qa-cluster"
aks_dns_prefix   = "aksqa"
aks_node_count   = 2
aks_node_vm_size = "Standard_B2s"

# PostgreSQL (Azure CAF Standard: psql-<app>-<env>-<instance>)
postgres_name          = "psql-axion-qa-01"
postgres_location      = "centralus"
db_admin_username      = "psqladmin"
db_admin_password      = "Axion#Qa2026!Pass"
postgres_sku_name      = "B_Standard_B2s"
postgres_database_name = "axiondb"

tags = {
  Environment = "qa"
  Project     = "Axion-Platform"
  ManagedBy   = "Terraform"
}
