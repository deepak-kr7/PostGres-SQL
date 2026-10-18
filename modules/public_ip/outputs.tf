output "public_ip_ids" {
  value       = { for k, v in azurerm_public_ip.pip : k => v.id }
  description = "Map of public IP keys to their resource IDs"
}

output "public_ip_addresses" {
  value       = { for k, v in azurerm_public_ip.pip : k => v.ip_address }
  description = "Map of public IP keys to their IP addresses"
}
