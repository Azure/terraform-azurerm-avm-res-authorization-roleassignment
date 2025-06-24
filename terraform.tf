terraform {
  required_version = "~> 1.6"
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = ">= 2.46, < 4.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.71, < 5.0"
    }
    modtm = {
      source  = "azure/modtm"
      version = "~> 0.3"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
  }
}
