output "name" {
  value       = azurerm_virtual_network.vnet.name
  description = "Virtual Network name"
}

output "id" {
  value       = azurerm_virtual_network.vnet.id
  description = "Virtual Network ID"
}

output "address_space" {
  value       = azurerm_virtual_network.vnet.address_space
  description = "Virtual Network address space"
}
