# VM Module ke liye password output
output "vm_admin_password" {
  value       = azurerm_key_vault_secret.vm_secret.value
  sensitive   = true
  description = "VM Admin password (from Key Vault secret)"
}

# PostgreSQL Module ke liye password output
output "db_admin_password" {
  value       = azurerm_key_vault_secret.db_secret.value
  sensitive   = true
  description = "Database Admin password (from Key Vault secret)"
}

# Key Vault Name output
output "key_vault_name" {
  value       = azurerm_key_vault.kv.name
  description = "Created Azure Key Vault Name"
}

# Key Vault URI output
output "key_vault_uri" {
  value       = azurerm_key_vault.kv.vault_uri
  description = "Azure Key Vault URI"
}
