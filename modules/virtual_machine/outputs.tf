output "vm_ids" {
  value       = { for k, v in azurerm_linux_virtual_machine.vm : k => v.id }
  description = "Map of VM keys to VM resource IDs"
}

output "private_ip_addresses" {
  value       = { for k, v in azurerm_linux_virtual_machine.vm : k => v.private_ip_address }
  description = "Map of VM keys to private IP addresses"
}
