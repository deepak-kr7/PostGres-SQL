variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
}

variable "location" {
  type        = string
  description = "Azure region for network interfaces"
}

variable "nics" {
  type = map(object({
    name         = string
    subnet_id    = string
    public_ip_id = optional(string)
  }))
  description = "Map of NICs configuration with direct subnet_id"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags for network interfaces"
}
