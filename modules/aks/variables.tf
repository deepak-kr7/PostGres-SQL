variable "name" {
  type        = string
  description = "Name of the AKS cluster"
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
}

variable "location" {
  type        = string
  description = "Azure region for the AKS cluster"
}

variable "dns_prefix" {
  type        = string
  default     = "appaks1"
  description = "DNS prefix for the AKS cluster"
}

variable "node_count" {
  type        = number
  default     = 1
  description = "Number of worker nodes in default node pool"
}

variable "node_vm_size" {
  type        = string
  default     = "Standard_D2s_v5"
  description = "VM size for the default node pool"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags for AKS cluster"
}
