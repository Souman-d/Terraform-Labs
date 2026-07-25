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

resource "azurerm_public_ip" "public_ip" {
  name                = "public_ip_p1"
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = azurerm_resource_group.resource_group.location
  allocation_method   = "Static"

  tags = {
    environment = "Production"
  }

depends_on = [ azurerm_resource_group.resource_group ]  
}