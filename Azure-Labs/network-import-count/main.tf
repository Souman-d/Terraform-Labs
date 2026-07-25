# 1. Create 3 Public Subnets
resource "azurerm_subnet" "public" {
  count                = 3
  name                 = local.public_subnet_names[count.index]
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name

  # Generates: 10.0.0.0/24, 10.0.1.0/24, 10.0.2.0/24 (assuming VNet is 10.0.0.0/16)
  address_prefixes = [cidrsubnet(tolist(azurerm_virtual_network.vnet.address_space)[0], 8, count.index)]
}

# 2. Create 3 Private Subnets
resource "azurerm_subnet" "private" {
  count                = 3
  name                 = local.private_subnet_names[count.index]
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name

  # Generates: 10.0.10.0/24, 10.0.11.0/24, 10.0.12.0/24 (offset by +10 to avoid collisions)
  address_prefixes = [cidrsubnet(tolist(azurerm_virtual_network.vnet.address_space)[0], 8, count.index + 10)]
}