output "id" {
  value       = azurerm_container_registry.acr.id
  description = "ACR ID"
}

output "name" {
  value       = azurerm_container_registry.acr.name
  description = "ACR Name"
}

output "login_server" {
  value       = azurerm_container_registry.acr.login_server
  description = "ACR login server URL"
}

output "admin_username" {
  value       = azurerm_container_registry.acr.admin_username
  description = "ACR admin username"
}

output "admin_password" {
  value       = azurerm_container_registry.acr.admin_password
  sensitive   = true
  description = "ACR admin password"
}
