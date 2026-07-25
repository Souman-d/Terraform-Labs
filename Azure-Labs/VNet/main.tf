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

locals {
  storage_account_name = "mystorageaccount990999"
  resource_group_name  = "rg-terraform-azure"
  location             = "East US"
}

resource "azurerm_resource_group" "resource_group" {
  name     = local.resource_group_name
  location = local.location
}

resource "azurerm_virtual_network" "vnet1" {
  name                = "vnet1-terraform"
  location            = local.location
  resource_group_name = local.resource_group_name
  address_space       = ["10.0.0.0/16"]
 
  subnet {
    name             = "app-subnet"
    address_prefixes = ["10.0.1.0/24"]
  }

  subnet {
    name             = "db-subnet"
    address_prefixes = ["10.0.2.0/24"]
      }

depends_on = [ azurerm_resource_group.resource_group ]
}