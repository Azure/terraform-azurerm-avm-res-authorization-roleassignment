locals {
  role_assignments_for_resources = {
    test1 = {
      resource_group_name = azapi_resource.resource_group.name
      resource_name       = azapi_resource.static_web_app[local.system_assigned_managed_identities.sami1].name
      role_assignments = {
        role_assignment1 = {
          role_definition                    = "role1"
          app_registrations                  = [local.app_registrations.app_registration1]
          system_assigned_managed_identities = [local.system_assigned_managed_identities.sami1]
          user_assigned_managed_identities   = [local.user_assigned_managed_identities.uami1]
          any_principals = [
            local.system_assigned_managed_identities.sami5,
            local.user_assigned_managed_identities.uami5,
          ]
        }
        role_assignment2 = {
          role_definition                    = "role2"
          app_registrations                  = [local.app_registrations.app_registration2]
          system_assigned_managed_identities = [local.system_assigned_managed_identities.sami2]
          user_assigned_managed_identities   = [local.user_assigned_managed_identities.uami2]
        }
        role_assignment3 = {
          role_definition                    = "role3"
          system_assigned_managed_identities = [local.system_assigned_managed_identities.sami3]
          user_assigned_managed_identities   = [local.user_assigned_managed_identities.uami3]
        }
        role_assignment4 = {
          role_definition                    = "role4"
          system_assigned_managed_identities = [local.system_assigned_managed_identities.sami4]
          user_assigned_managed_identities   = [local.user_assigned_managed_identities.uami4]
      } }
    }
    test2 = {
      resource_group_name = azapi_resource.resource_group.name
      resource_name       = azapi_resource.static_web_app[local.system_assigned_managed_identities.sami2].name
      role_assignments = {
        role_assignment1 = {
          role_definition                  = "role3"
          user_assigned_managed_identities = [local.user_assigned_managed_identities.uami6]
        }
      }
    }
  }
}
