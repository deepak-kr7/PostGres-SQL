variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
}

variable "virtual_network_name" {
  type        = string
  description = "Name of the virtual network"
}

variable "subnets" {
  type = map(object({
    name             = string
    address_prefixes = list(string)
  }))
  description = "Map of subnets (frontend, backend, database, aks) with address prefixes"
}
