locals {
  role_assignments_for_management_groups = {
    # Both entries target the test management group, so they use different roles or principals.
    test1 = {
      management_group_display_name = local.test_management_group_name
      role_assignments = {
        role_assignment1 = {
          role_definition                  = "role2"
          user_assigned_managed_identities = [local.user_assigned_managed_identities.uami6]
        }
      }
    }
    test2 = {
      management_group_id = azapi_resource.management_group.name
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
  }
}
