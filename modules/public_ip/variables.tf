variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
}

variable "location" {
  type        = string
  description = "Azure region for public IPs"
}

variable "public_ips" {
  type = map(object({
    name              = string
    allocation_method = string
    sku               = string
  }))
  default     = {}
  description = "Map of public IPs to create"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags for public IPs"
}
