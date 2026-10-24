variable "name" {
  type        = string
  description = "Azure Key Vault ka unique naam (3-24 characters)"
}

variable "resource_group_name" {
  type        = string
  description = "Resource Group ka naam jisme Key Vault banega"
}

variable "location" {
  type        = string
  description = "Azure location (jaise eastus, centralus)"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags"
}
