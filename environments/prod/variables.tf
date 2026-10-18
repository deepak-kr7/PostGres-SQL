variable "subscription_id" {
  type        = string
  description = "Azure Subscription ID"
}

variable "environment" {
  type        = string
  description = "Environment name (dev, qa, prod)"
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
}

variable "location" {
  type        = string
  default     = "eastus"
  description = "Azure region"
}

# Network
variable "vnet_name" {
  type        = string
  description = "Name of the virtual network"
}

variable "address_space" {
  type        = list(string)
  default     = ["10.30.0.0/16"]
  description = "Address space for the virtual network"
}

variable "subnets" {
  type = map(object({
    name             = string
    address_prefixes = list(string)
  }))
  description = "Map of subnets for frontend, backend, database tiers"
}

variable "public_ips" {
  type = map(object({
    name              = string
    allocation_method = string
    sku               = string
  }))
  default     = {}
  description = "Map of public IPs"
}

variable "nics" {
  type = map(object({
    name          = string
    subnet_key    = string
    public_ip_key = optional(string)
  }))
  description = "Map of NICs configuration"
}

# Virtual Machines
variable "vm_admin_username" {
  type        = string
  default     = "azureuser"
  description = "VM Admin username"
}

variable "vm_admin_password" {
  type        = string
  sensitive   = true
  description = "VM Admin password"
}

variable "vms" {
  type = map(object({
    name            = string
    vm_size         = string
    nic_name        = string
    os_disk_type    = string
    os_disk_size_gb = number
  }))
  description = "Map of 3 virtual machines (frontend, backend, database)"
}

# ACR
variable "acr_name" {
  type        = string
  description = "Name of the Azure Container Registry"
}

variable "acr_sku" {
  type        = string
  default     = "Premium"
  description = "ACR SKU"
}

# AKS
variable "aks_name" {
  type        = string
  description = "Name of the AKS cluster"
}

variable "aks_dns_prefix" {
  type        = string
  default     = "appaks1"
  description = "DNS prefix for AKS"
}

variable "aks_node_count" {
  type        = number
  default     = 3
  description = "AKS node count"
}

variable "aks_node_vm_size" {
  type        = string
  default     = "Standard_D4s_v5"
  description = "AKS node VM size"
}

# PostgreSQL
variable "postgres_name" {
  type        = string
  description = "Name of the PostgreSQL Flexible Server"
}

variable "postgres_location" {
  type        = string
  default     = "centralus"
  description = "Location for PostgreSQL server"
}

variable "db_admin_username" {
  type        = string
  default     = "psqladmin"
  description = "Database administrator username"
}

variable "db_admin_password" {
  type        = string
  sensitive   = true
  description = "Database administrator password"
}

variable "postgres_sku_name" {
  type        = string
  default     = "GP_Standard_D2s_v3"
  description = "SKU for PostgreSQL server"
}

variable "postgres_database_name" {
  type        = string
  default     = "axiondb"
  description = "Initial database name"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags to apply"
}
