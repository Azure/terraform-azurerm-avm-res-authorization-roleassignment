locals {
  all_principals = merge(
    { for key, value in local.users : key => {
      principal_id = value
      type         = "user"
      }
    },
    { for key, value in local.groups : key => {
      principal_id = value
      type         = "group"
      }
    },
    { for key, value in local.app_registrations : key => {
      principal_id = value
      type         = "app_registration"
      }
    },
    { for key, value in local.system_assigned_managed_identities : key => {
      principal_id = value
      type         = "system_assigned_managed_identity"
      }
    },
    { for key, value in local.user_assigned_managed_identities : key => {
      principal_id = value
      type         = "user_assigned_managed_identity"
      }
    }
  )
  default_subscription_id = data.azurerm_client_config.current.subscription_id
}
