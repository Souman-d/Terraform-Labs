terraform {
  required_version = ">= 1.5.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  features {}
}

locals {
  # Match these to your existing manually created resource names in Azure
  resource_group_name = "my-rg-terraform"
  vnet_name           = "test-vnet"

  # Define subnet names for clean iteration
  public_subnet_names  = ["subnet-public-1", "subnet-public-2", "subnet-public-3"]
  private_subnet_names = ["subnet-private-1", "subnet-private-2", "subnet-private-3"]
}