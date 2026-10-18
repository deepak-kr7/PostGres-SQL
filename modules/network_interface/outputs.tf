output "nic_ids" {
  value       = { for k, v in azurerm_network_interface.nic : k => v.id }
  description = "Map of NIC keys to NIC resource IDs"
}

output "nic_names" {
  value       = { for k, v in azurerm_network_interface.nic : k => v.name }
  description = "Map of NIC keys to NIC names"
}

output "private_ip_addresses" {
  value       = { for k, v in azurerm_network_interface.nic : k => v.private_ip_address }
  description = "Map of NIC keys to assigned private IP addresses"
}
