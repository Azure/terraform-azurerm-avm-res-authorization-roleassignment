terraform {
  required_version = "~> 1.6"

  required_providers {
    azapi = {
      source  = "Azure/azapi"
      version = "~> 2.12"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = ">= 2.46, < 4.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
  }
}

locals {
  module_name = "apar"
  users = {
    user1 = "user1"
    user2 = "user2"
    user3 = "user3"
    user4 = "user4"
    user5 = "user5"
    user6 = "user6"
    user7 = "user7"
    user8 = "user8"
  }
}

resource "random_pet" "username" {
  for_each = local.users

  length    = 2
  separator = "-"
}

resource "random_password" "password" {
  for_each = local.users

  length           = 20
  min_lower        = 1
  min_numeric      = 1
  min_special      = 1
  min_upper        = 1
  override_special = "_%@"
  special          = true
}

resource "random_string" "employee_id" {
  for_each = local.users

  length  = 10
  lower   = false
  numeric = true
  special = false
  upper   = false
}

resource "azuread_user" "test" {
  for_each = local.users

  display_name        = "${local.module_name}-${each.key}-${random_pet.username[each.key].id}"
  user_principal_name = "${each.key}-${random_pet.username[each.key].id}@${var.spn_domain}"
  account_enabled     = false
  employee_id         = random_string.employee_id[each.key].result
  mail                = "${each.key}-${random_pet.username[each.key].id}@avm-test.com"
  mail_nickname       = "${each.key}-${random_pet.username[each.key].id}"
  password            = random_password.password[each.key].result
}

data "azapi_client_config" "current" {}

module "role_assignments" {
  source = "../../"

  # source = "Azure/avm-ptn-authorization-roleassignment/azurerm"
  enable_telemetry = var.enable_telemetry
  entra_id_role_definitions = {
    directory-reader = {
      display_name = "Directory Readers"
    }
  }
  role_assignments_azure_resource_manager = {
    for key, value in local.users : key => {
      principal_id       = azuread_user.test[key].object_id
      role_definition_id = "/subscriptions/${data.azapi_client_config.current.subscription_id}/providers/Microsoft.Authorization/roleDefinitions/8e3af657-a8ff-443c-a75c-2fe8c4bcb635"
      scope              = "/subscriptions/${data.azapi_client_config.current.subscription_id}"
    }
  }
  role_assignments_for_entra_id = {
    directory_reader = {
      role_assignments = {
        directory_reader = {
          role_definition     = "directory-reader"
          principal_object_id = "00000000-0000-0000-0000-000000000001"
        }
      }
    }
  }
}
