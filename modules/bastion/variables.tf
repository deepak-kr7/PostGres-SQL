variable "name" {
  type        = string
  description = "Azure Bastion Host Name"
}

variable "resource_group_name" {
  type        = string
  description = "Resource Group ka naam"
}

variable "location" {
  type        = string
  description = "Azure Region (jaise eastus)"
}

variable "virtual_network_name" {
  type        = string
  description = "Virtual Network ka naam jisme AzureBastionSubnet banega"
}

variable "bastion_subnet_address_prefixes" {
  type        = list(string)
  default     = ["10.10.0.0/26"]
  description = "Address prefix for AzureBastionSubnet (minimum /26 required)"
}

variable "bastion_public_ip_name" {
  type        = string
  description = "Bastion ke Public IP ka naam"
}

variable "sku" {
  type        = string
  default     = "Standard"
  description = "Bastion SKU (Basic, Standard, ya Premium)"
}

variable "scale_units" {
  type        = number
  default     = 2
  description = "Bastion scale units (2-50 for Standard/Premium)"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags"
}
