# 1. Resource Group representation
resource "azurerm_resource_group" "rg" {
  name     = local.resource_group_name
  location = "East US" # Will be updated automatically upon import if different
}

# Native import block for Resource Group
import {
  to = azurerm_resource_group.rg
  id = "/subscriptions/e20eb20b-7ae2-41e0-8859-e917c49d2194/resourceGroups/${local.resource_group_name}"
}

# 2. Virtual Network representation
resource "azurerm_virtual_network" "vnet" {
  name                = local.vnet_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"] # Adjust to match your existing VNet space
}

# Native import block for Virtual Network
import {
  to = azurerm_virtual_network.vnet
  id = "/subscriptions/e20eb20b-7ae2-41e0-8859-e917c49d2194/resourceGroups/${local.resource_group_name}/providers/Microsoft.Network/virtualNetworks/${local.vnet_name}"
}