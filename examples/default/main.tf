terraform {
  required_version = ">= 1.3.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.7.0, < 4.0.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = ">= 2.0.0, < 3.0.0"
    }
  }
}

provider "azurerm" {
  features {}
}

locals {
  module_name = "apar"
}

resource "random_pet" "resource_group_name" {
  length    = 2
  separator = "-"
}

resource "azurerm_resource_group" "test" {
  name     = "${local.module_name}-${random_pet.resource_group_name.id}"
  location = "westeurope"
}

module "avm-ptn-authorization-roleassignment" {
  source = "../../"
  # source = "Azure/avm-ptn-authorization-roleassignment/azurerm"
  enable_telemetry = var.enable_telemetry

  depends_on = [azuread_service_principal.test, azuread_user.test, azuread_group.test, azuread_application.test, azurerm_static_site.test, azurerm_user_assigned_identity.test]

  users_by_user_principal_name = {
    (local.users.user1) = azuread_user.test[local.users.user1].user_principal_name
    (local.users.user2) = azuread_user.test[local.users.user2].user_principal_name
  }
  users_by_mail = {
    (local.users.user1) = azuread_user.test[local.users.user1].mail
    (local.users.user3) = azuread_user.test[local.users.user3].mail
  }
  users_by_mail_nickname = {
    (local.users.user1) = azuread_user.test[local.users.user1].mail_nickname
    (local.users.user4) = azuread_user.test[local.users.user4].mail_nickname
  }
  users_by_employee_id = {
    (local.users.user1) = azuread_user.test[local.users.user1].employee_id
    (local.users.user5) = azuread_user.test[local.users.user5].employee_id
  }
  users_by_object_id = {
    (local.users.user1) = azuread_user.test[local.users.user1].object_id
    (local.users.user6) = azuread_user.test[local.users.user6].object_id
  }

  groups_by_display_name = {
    (local.groups.group1) = azuread_group.test[local.groups.group1].display_name
    (local.groups.group2) = azuread_group.test[local.groups.group2].display_name
  }
  groups_by_mail_nickname = {
    (local.groups.group1) = azuread_group.test[local.groups.group1].mail_nickname
    (local.groups.group3) = azuread_group.test[local.groups.group3].mail_nickname
  }
  groups_by_object_id = {
    (local.groups.group1) = azuread_group.test[local.groups.group1].object_id
    (local.groups.group4) = azuread_group.test[local.groups.group4].object_id
  }

  app_registrations_by_display_name = {
    (local.app_registrations.app_registration1) = azuread_application.test[local.app_registrations.app_registration1].display_name
    (local.app_registrations.app_registration2) = azuread_application.test[local.app_registrations.app_registration2].display_name
  }
  app_registrations_by_client_id = {
    (local.app_registrations.app_registration1) = azuread_application.test[local.app_registrations.app_registration1].client_id
    (local.app_registrations.app_registration3) = azuread_application.test[local.app_registrations.app_registration3].client_id
  }
  app_registrations_by_object_id = {
    (local.app_registrations.app_registration1) = azuread_application.test[local.app_registrations.app_registration1].object_id
    (local.app_registrations.app_registration4) = azuread_application.test[local.app_registrations.app_registration4].object_id
  }
  app_registrations_by_principal_id = {
    (local.app_registrations.app_registration1) = azuread_service_principal.test[local.app_registrations.app_registration1].object_id
    (local.app_registrations.app_registration5) = azuread_service_principal.test[local.app_registrations.app_registration5].object_id
  }

  system_assigned_managed_identities_by_display_name = {
    (local.system_assigned_managed_identities.sami1) = azurerm_static_site.test[local.system_assigned_managed_identities.sami1].name
    (local.system_assigned_managed_identities.sami2) = azurerm_static_site.test[local.system_assigned_managed_identities.sami2].name
  }
  system_assigned_managed_identities_by_principal_id = {
    (local.system_assigned_managed_identities.sami1) = azurerm_static_site.test[local.system_assigned_managed_identities.sami1].identity[0].principal_id
    (local.system_assigned_managed_identities.sami3) = azurerm_static_site.test[local.system_assigned_managed_identities.sami3].identity[0].principal_id
  }
  system_assigned_managed_identities_by_client_id = {
    (local.system_assigned_managed_identities.sami1) = data.azuread_service_principal.test[local.system_assigned_managed_identities.sami1].client_id
    (local.system_assigned_managed_identities.sami4) = data.azuread_service_principal.test[local.system_assigned_managed_identities.sami4].client_id
  }

  user_assigned_managed_identities_by_resource_group_and_name = {
    (local.user_assigned_managed_identities.uami1) = {
      name                = azurerm_user_assigned_identity.test[local.user_assigned_managed_identities.uami1].name
      resource_group_name = azurerm_user_assigned_identity.test[local.user_assigned_managed_identities.uami1].resource_group_name
    }
    (local.user_assigned_managed_identities.uami2) = {
      name                = azurerm_user_assigned_identity.test[local.user_assigned_managed_identities.uami2].name
      resource_group_name = azurerm_user_assigned_identity.test[local.user_assigned_managed_identities.uami2].resource_group_name
    }
  }
  user_assigned_managed_identities_by_display_name = {
    (local.user_assigned_managed_identities.uami1) = azurerm_user_assigned_identity.test[local.user_assigned_managed_identities.uami2].name
    (local.user_assigned_managed_identities.uami3) = azurerm_user_assigned_identity.test[local.user_assigned_managed_identities.uami2].name
  }
  user_assigned_managed_identities_by_client_id = {
    (local.user_assigned_managed_identities.uami1) = azurerm_user_assigned_identity.test[local.user_assigned_managed_identities.uami1].client_id
    (local.user_assigned_managed_identities.uami4) = azurerm_user_assigned_identity.test[local.user_assigned_managed_identities.uami4].client_id
  }
  user_assigned_managed_identities_by_principal_id = {
    (local.user_assigned_managed_identities.uami1) = azurerm_user_assigned_identity.test[local.user_assigned_managed_identities.uami1].principal_id
    (local.user_assigned_managed_identities.uami5) = azurerm_user_assigned_identity.test[local.user_assigned_managed_identities.uami5].principal_id
  }

  role_definitions = {
    role1 = "Owner"
    role2 = "Contributor"
    role3 = "Reader"
  }

  role_assignments_by_resources_by_resource_group_and_name = {
    test1 = {
      resource_group_name = azurerm_resource_group.test.name
      resource_name       = azurerm_static_site.test[local.system_assigned_managed_identities.sami1].name
      role_assignments = {
        role_assignment1 = {
          role_definition                    = "role1"
          users                              = [local.users.user1]
          groups                             = [local.groups.group1]
          app_registrations                  = [local.app_registrations.app_registration1]
          system_assigned_managed_identities = [local.system_assigned_managed_identities.sami1]
          user_assigned_managed_identities   = [local.user_assigned_managed_identities.uami1]
        }
        role_assignment2 = {
          role_definition                    = "role2"
          users                              = [local.users.user2]
          groups                             = [local.groups.group2]
          app_registrations                  = [local.app_registrations.app_registration2]
          system_assigned_managed_identities = [local.system_assigned_managed_identities.sami2]
          user_assigned_managed_identities   = [local.user_assigned_managed_identities.uami2]
        }
        role_assignment3 = {
          role_definition                    = "role3"
          users                              = [local.users.user3]
          groups                             = [local.groups.group3]
          app_registrations                  = [local.app_registrations.app_registration3]
          system_assigned_managed_identities = [local.system_assigned_managed_identities.sami3]
          user_assigned_managed_identities   = [local.user_assigned_managed_identities.uami3]
        }
      }
    }
  }
}
