terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.81.0"
    }
  }
}

provider "azurerm" {
  subscription_id = "e20eb20b-7ae2-41e0-8859-e917c49d2194"
  features {}
}

resource "azurerm_resource_group" "resource_group" {
  name     = "rg-terraform-azure"
  location = "East US"
}

resource "azurerm_network_security_group" "terraform_nsg" {
  name                = "terraform_nsg"
  location            = azurerm_resource_group.resource_group.location
  resource_group_name = azurerm_resource_group.resource_group.name

 # We are creating a rule to allow traffic on port 80
  security_rule {
    name                       = "Allow_HTTP"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"

  }
}