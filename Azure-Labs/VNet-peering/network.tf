locals {
  resource_group_name = "rg-terraform-azure"
  location            = "East US"
}

# 1. Resource Group
resource "azurerm_resource_group" "rg" {
  name     = local.resource_group_name
  location = local.location
}

# 2. VNet 1 & Subnet 1
resource "azurerm_virtual_network" "vnet1" {
  name                = "peer1-vnet"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "subnet1" {
  name                 = "peer1-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet1.name
  address_prefixes     = ["10.0.1.0/24"]
}

# 3. VNet 2 & Subnet 2
resource "azurerm_virtual_network" "vnet2" {
  name                = "peer2-vnet"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.1.0.0/16"]
}

resource "azurerm_subnet" "subnet2" {
  name                 = "peer2-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet2.name
  address_prefixes     = ["10.1.1.0/24"]
}

# 4. Peering: VNet 1 -> VNet 2
resource "azurerm_virtual_network_peering" "peer1_to_peer2" {
  name                         = "peer1-to-peer2"
  resource_group_name          = azurerm_resource_group.rg.name
  virtual_network_name         = azurerm_virtual_network.vnet1.name
  remote_virtual_network_id    = azurerm_virtual_network.vnet2.id
  
  # Explicit Traffic Controls
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = false

  # Ensure subnets exist before establishing peering link
  depends_on = [
    azurerm_subnet.subnet1,
    azurerm_subnet.subnet2
  ]
}

# 5. Peering: VNet 2 -> VNet 1
resource "azurerm_virtual_network_peering" "peer2_to_peer1" {
  name                         = "peer2-to-peer1"
  resource_group_name          = azurerm_resource_group.rg.name
  virtual_network_name         = azurerm_virtual_network.vnet2.name
  remote_virtual_network_id    = azurerm_virtual_network.vnet1.id
  
  # Explicit Traffic Controls
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  use_remote_gateways          = false

  # Ensure subnets exist before establishing peering link
  depends_on = [
    azurerm_subnet.subnet1,
    azurerm_subnet.subnet2
  ]
}