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

resource "azurerm_storage_account" "storage_account" {
  name                     = local.storage_account_name
  resource_group_name      = local.resource_group_name
  location                 = local.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"

  depends_on = [ azurerm_resource_group.resource_group ]
}

resource "azurerm_storage_container" "mycontainer" {
  name                  = "data"
  storage_account_id    = azurerm_storage_account.storage_account.id
  container_access_type = "blob"

  depends_on = [ azurerm_storage_account.storage_account ]
}

resource "azurerm_storage_blob" "blobdetails" {
  name                 = "script.txt"
  storage_container_id = azurerm_storage_container.mycontainer.id 
  type                 = "Block"
  source               = "test.txt" 

  depends_on = [ azurerm_storage_container.mycontainer ]
}