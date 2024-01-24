terraform {
  required_version = "~> 1.6"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.7"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.46"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
    time = {
      source  = "hashicorp/time"
      version = "~> 0.7"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "azurerm" {
  alias           = "alternative"
  subscription_id = var.alternative_subscription_id
  features {}
}
