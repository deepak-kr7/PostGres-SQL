variable "name" {
  type        = string
  description = "Name of the Azure Container Registry (must be globally unique and alphanumeric)"
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
}

variable "location" {
  type        = string
  description = "Azure region for ACR"
}

variable "sku" {
  type        = string
  default     = "Basic"
  description = "SKU for ACR (Basic, Standard, Premium)"
}

variable "admin_enabled" {
  type        = bool
  default     = true
  description = "Enable admin user on ACR"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags for ACR"
}
