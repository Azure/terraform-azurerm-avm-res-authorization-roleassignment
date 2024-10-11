locals {
  role_assignments_for_resources = {
    test1 = {
      resource_group_name = azurerm_resource_group.test.name
      resource_name       = azurerm_static_web_app.test[local.system_assigned_managed_identities.sami1].name
      role_assignments = {
        role_assignment1 = {
          role_definition                    = "role1"
          users                              = [local.users.user1, local.users.user4]
          groups                             = [local.groups.group1]
          app_registrations                  = [local.app_registrations.app_registration1]
          system_assigned_managed_identities = [local.system_assigned_managed_identities.sami1]
          user_assigned_managed_identities   = [local.user_assigned_managed_identities.uami1]
          any_principals = [
            local.users.user2,
            local.users.user7,
            local.groups.group5,
            local.app_registrations.app_registration5,
            local.system_assigned_managed_identities.sami5,
            local.user_assigned_managed_identities.uami5,
          ]
        }
        role_assignment2 = {
          role_definition                    = "role2"
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
        role_assignment4 = {
          role_definition                    = "role4"
          users                              = [local.users.user4]
          groups                             = [local.groups.group4]
          app_registrations                  = [local.app_registrations.app_registration4]
          system_assigned_managed_identities = [local.system_assigned_managed_identities.sami4]
          user_assigned_managed_identities   = [local.user_assigned_managed_identities.uami4]
        }
      }
    }
    test2 = {
      resource_group_name = azurerm_resource_group.test.name
      resource_name       = azurerm_static_web_app.test[local.system_assigned_managed_identities.sami2].name
      role_assignments = {
        role_assignment1 = {
          role_definition = "role3"
          users           = [local.users.user5]
        }
      }
    }
  }
}
