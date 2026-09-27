terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "5.7.0"
    }
  }
}

provider "azurerm" {
  features {}
}


resource "azurerm_resource_group" "terraform_azure_providers" {
  name     = "terraform_azure_provider"
  location = "East US"
}
