terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }
  
  backend "azurerm" {
    resource_group_name  = "tfstate"
    storage_account_name = "tfstatehxyz4"
    container_name       = "tfstate"
    key                  = "tfstate"

  }
}

provider "azurerm" {
  features {}
  # disable automatic registration of Azure resource provider
  skip_provider_registration = true
  client_id                  = ""
  client_secret              = ""
  tenant_id                  = ""
  subscription_id            = ""
}

