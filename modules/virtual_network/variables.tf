variable "name" {
  type        = string
  description = "Name of the virtual network"
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group where the VNet will be placed"
}

variable "location" {
  type        = string
  description = "Azure region for the virtual network"
}

variable "address_space" {
  type        = list(string)
  default     = ["10.0.0.0/16"]
  description = "Address space for the virtual network"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags for the virtual network"
}
