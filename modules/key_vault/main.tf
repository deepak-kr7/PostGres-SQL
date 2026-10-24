# ==============================================================================
# Azure Key Vault Module - Simple & Easy to Understand
# 1. Key Vault banata hai
# 2. VM aur Database ke liye secure passwords generate karta hai
# 3. Dono passwords ko Key Vault mein secrets ki tarah store karta hai
# ==============================================================================

# Step 1: Azure Subscription aur Tenant details fetch karna
data "azurerm_client_config" "current" {}

# Step 2: Azure Key Vault Resource
resource "azurerm_key_vault" "kv" {
  name                       = var.name
  location                   = var.location
  resource_group_name        = var.resource_group_name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  rbac_authorization_enabled = false

  # Access Policy: Terraform ko Secret create aur read karne ki permission
  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    secret_permissions = [
      "Get",
      "List",
      "Set",
      "Delete",
      "Purge"
    ]
  }

  tags = var.tags
}

# Step 3: VM ke liye automatic strong password generate karna
resource "random_password" "vm_password" {
  length  = 16
  special = true
}

# Step 4: Database ke liye automatic strong password generate karna
resource "random_password" "db_password" {
  length  = 16
  special = true
}

# Step 5: VM Password ko Key Vault Secret mein save karna
resource "azurerm_key_vault_secret" "vm_secret" {
  name         = "vm-admin-password"
  value        = random_password.vm_password.result
  key_vault_id = azurerm_key_vault.kv.id
}

# Step 6: Database Password ko Key Vault Secret mein save karna
resource "azurerm_key_vault_secret" "db_secret" {
  name         = "db-admin-password"
  value        = random_password.db_password.result
  key_vault_id = azurerm_key_vault.kv.id
}
