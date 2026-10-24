# ==============================================================================
# Azure Bastion Module - Simple & Easy to Understand
# 1. AzureBastionSubnet banata hai (minimum /26 prefix)
# 2. Bastion ke liye Dedicated Standard Public IP banata hai
# 3. Azure Bastion Host banata hai
# ==============================================================================

# Step 1: AzureBastionSubnet
resource "azurerm_subnet" "bastion_subnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.virtual_network_name
  address_prefixes     = var.bastion_subnet_address_prefixes
}

# Step 2: Bastion Public IP
resource "azurerm_public_ip" "bastion_pip" {
  name                = var.bastion_public_ip_name
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

# Step 3: Azure Bastion Host Resource
resource "azurerm_bastion_host" "bastion" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.sku
  scale_units         = var.scale_units
  tags                = var.tags

  ip_configuration {
    name                 = "IpConf"
    subnet_id            = azurerm_subnet.bastion_subnet.id
    public_ip_address_id = azurerm_public_ip.bastion_pip.id
  }
}
