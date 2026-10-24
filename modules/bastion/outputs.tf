output "bastion_id" {
  value       = azurerm_bastion_host.bastion.id
  description = "Azure Bastion Host ID"
}

output "bastion_name" {
  value       = azurerm_bastion_host.bastion.name
  description = "Azure Bastion Host Name"
}

output "bastion_dns_name" {
  value       = azurerm_bastion_host.bastion.dns_name
  description = "Azure Bastion FQDN / DNS Name"
}

output "bastion_public_ip" {
  value       = azurerm_public_ip.bastion_pip.ip_address
  description = "Azure Bastion Public IP Address"
}
