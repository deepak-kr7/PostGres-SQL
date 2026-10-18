variable "name" {
  type        = string
  description = "Name of the PostgreSQL Flexible Server (globally unique)"
}

variable "resource_group_name" {
  type        = string
  description = "Name of the resource group"
}

variable "location" {
  type        = string
  default     = null
  description = "Azure region (defaults to RG location if not specified)"
}

variable "postgres_version" {
  type        = string
  default     = "15"
  description = "PostgreSQL major version"
}

variable "db_admin_username" {
  type        = string
  default     = "psqladmin"
  description = "PostgreSQL admin username"
}

variable "db_admin_password" {
  type        = string
  sensitive   = true
  description = "PostgreSQL admin password"
}

variable "sku_name" {
  type        = string
  default     = "B_Standard_B1ms"
  description = "SKU for PostgreSQL Flexible Server"
}

variable "storage_mb" {
  type        = number
  default     = 32768
  description = "Storage in MB"
}

variable "zone" {
  type        = string
  default     = "1"
  description = "Availability zone"
}

variable "database_name" {
  type        = string
  default     = "axiondb"
  description = "Initial database name"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Tags for PostgreSQL Flexible Server"
}
