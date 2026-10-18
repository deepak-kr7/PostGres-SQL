output "subnet_ids" {
  value       = { for k, v in azurerm_subnet.subnet : k => v.id }
  description = "Map of subnet keys to their Subnet resource IDs"
}

output "subnet_names" {
  value       = { for k, v in azurerm_subnet.subnet : k => v.name }
  description = "Map of subnet keys to their Subnet names"
}
