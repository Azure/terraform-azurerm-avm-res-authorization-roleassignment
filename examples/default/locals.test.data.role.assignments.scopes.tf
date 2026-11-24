locals {
  role_assignments_for_scopes = merge({
    test1 = {
      scope = azapi_resource.management_group.id
      role_assignments = {
        role_assignment1 = {
          role_definition                    = "role1"
          users                              = [local.users.user8]
          groups                             = [local.groups.group6]
          app_registrations                  = [local.app_registrations.app_registration7]
          system_assigned_managed_identities = [local.system_assigned_managed_identities.sami6]
          user_assigned_managed_identities   = [local.user_assigned_managed_identities.uami7]
        }
      }
    },
    test2 = {
      scope = azapi_resource.resource_group.id
      role_assignments = {
        role_assignment1 = {
          role_definition                    = "role1"
          users                              = [local.users.user8]
          groups                             = [local.groups.group6]
          app_registrations                  = [local.app_registrations.app_registration7]
          system_assigned_managed_identities = [local.system_assigned_managed_identities.sami6]
          user_assigned_managed_identities   = [local.user_assigned_managed_identities.uami7]
        }
      }
    },
    test3 = {
      scope = azapi_resource.static_web_app[local.system_assigned_managed_identities.sami1].id
      role_assignments = {
        role_assignment1 = {
          role_definition                    = "role1"
          users                              = [local.users.user8]
          groups                             = [local.groups.group6]
          app_registrations                  = [local.app_registrations.app_registration7]
          system_assigned_managed_identities = [local.system_assigned_managed_identities.sami6]
          user_assigned_managed_identities   = [local.user_assigned_managed_identities.uami7]
        }
      }
    },
    },
    local.include_alternative_subscription ? {
      test4 = {
        scope = "/subscriptions/${var.alternative_subscription_id}"
        role_assignments = {
          role_assignment1 = {
            role_definition                    = "role1"
            users                              = [local.users.user8]
            groups                             = [local.groups.group6]
            app_registrations                  = [local.app_registrations.app_registration7]
            system_assigned_managed_identities = [local.system_assigned_managed_identities.sami6]
            user_assigned_managed_identities   = [local.user_assigned_managed_identities.uami7]
          }
        }
      }
  } : {})
}
