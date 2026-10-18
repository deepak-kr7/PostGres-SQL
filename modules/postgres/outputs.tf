output "id" {
  value       = azurerm_postgresql_flexible_server.db.id
  description = "PostgreSQL Flexible Server ID"
}

output "fqdn" {
  value       = azurerm_postgresql_flexible_server.db.fqdn
  description = "PostgreSQL Flexible Server FQDN"
}

output "database_name" {
  value       = azurerm_postgresql_flexible_server_database.db.name
  description = "Database name"
}
