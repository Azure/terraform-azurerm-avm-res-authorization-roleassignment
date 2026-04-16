terraform {
  required_version = "~> 1.10"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.71, < 5.0"
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
  name                 = uuidv5("url", "${azurerm_resource_group.test.id}|Reader|${azurerm_user_assigned_identity.test.principal_id}")
  scope                = azurerm_resource_group.test.id
  role_definition_name = "Reader"
  principal_id         = azurerm_user_assigned_identity.test.principal_id
  principal_type       = "ServicePrincipal"

  lifecycle {
    ignore_changes = [name]
  }
}
