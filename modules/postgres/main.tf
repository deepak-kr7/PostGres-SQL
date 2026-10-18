resource "azurerm_postgresql_flexible_server" "db" {
  name                   = var.name
  resource_group_name    = var.resource_group_name
  location               = var.location
  version                = var.postgres_version
  administrator_login    = var.db_admin_username
  administrator_password = var.db_admin_password
  storage_mb             = var.storage_mb
  sku_name               = var.sku_name
  zone                   = var.zone
  tags                   = var.tags
}

resource "azurerm_postgresql_flexible_server_database" "db" {
  name      = var.database_name
  server_id = azurerm_postgresql_flexible_server.db.id
  collation = "en_US.utf8"
  charset   = "utf8"
}

resource "azurerm_postgresql_flexible_server_firewall_rule" "firewall" {
  name             = "allow-all"
  server_id        = azurerm_postgresql_flexible_server.db.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "255.255.255.255"
}
