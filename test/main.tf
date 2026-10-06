terraform {
  required_version = "~> 1.6"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 5.2, < 6.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "test" {
  name     = "rg-roleassignment-test-120"
  location = "eastus"
  tags = {
    "cost-center" : "GAZE",
    "environment" : "learning",
    "owner" : "AZE",
    "project" : "avm",
  }
}

resource "azurerm_user_assigned_identity" "test" {
  name                = "uid-roleassignment-test-120"
  resource_group_name = azurerm_resource_group.test.name
  location            = azurerm_resource_group.test.location
  tags = {
    "cost-center" : "GAZE",
    "environment" : "learning",
    "owner" : "AZE",
    "project" : "avm",
  }
}

# Direct test of the deterministic-GUID pattern used in main.tf.
# Bypasses the module to avoid pre-existing bugs in other locals.
resource "azurerm_role_assignment" "test" {
  name                 = uuidv5("11fb06fb-712d-4ddd-98c7-e71bbd588830", join("-", [lower(azurerm_resource_group.test.id), lower(azurerm_user_assigned_identity.test.principal_id), "acdd72a7-3385-48ef-bd42-f606fba81ae7"]))
  scope                = azurerm_resource_group.test.id
  role_definition_name = "Reader"
  principal_id         = azurerm_user_assigned_identity.test.principal_id
  principal_type       = "ServicePrincipal"

  lifecycle {
    ignore_changes = [name]
  }
}
