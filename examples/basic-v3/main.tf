terraform {
  required_version = "~> 1.6"
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.46"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.7, < 4.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
  }
}

provider "azurerm" {
  features {}
}

variable "spn_domain" {
  type        = string
  default     = "changeme.com"
  description = <<DESCRIPTION
The domain name that is post-fixed on the service principal name.
This must be a valid domain registered in your Entra ID tenant.
DESCRIPTION
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

data "azurerm_client_config" "current" {}

module "role_assignments" {
  source = "../../"
  # source = "Azure/avm-ptn-authorization-roleassignment/azurerm"
  enable_telemetry = false

  role_assignments_azure_resource_manager = {
    for key, value in local.users : key => {
      principal_id         = azuread_user.test[key].object_id
      role_definition_name = "Owner"
      scope                = "/subscriptions/${data.azurerm_client_config.current.subscription_id}"
    }
  }

  role_assignments_entra_id = {
    for key, value in local.users : key => {
      principal_object_id = azuread_user.test[key].object_id
      role_id             = "9b895d92-2cd3-44c7-9d02-a6ac2d5ea5c3"
    }
  }
}