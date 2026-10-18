variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
}

variable "location" {
  type        = string
  description = "Azure region for virtual machines"
}

variable "network_interface_ids" {
  type        = map(string)
  description = "Map of VM keys to NIC resource IDs"
}

variable "admin_username" {
  type        = string
  default     = "azureuser"
  description = "Administrator username for Linux VMs"
}

variable "admin_password" {
  type        = string
  sensitive   = true
  description = "Administrator password for Linux VMs"
}

variable "vms" {
  type = map(object({
    name            = string
    vm_size         = string
    nic_name        = string
    os_disk_type    = string
    os_disk_size_gb = number
  }))
  description = "Map of virtual machines (frontend, backend, database) with VM sizes and disk specifications"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags for virtual machines"
}
