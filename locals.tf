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
  # The namespaceId Bicep/ARM guid() uses, so names match guid(scope, principalId, roleDefinitionId):
  # https://learn.microsoft.com/azure/azure-resource-manager/bicep/bicep-functions-string#guid
  bicep_guid_namespace    = "11fb06fb-712d-4ddd-98c7-e71bbd588830"
  default_subscription_id = data.azurerm_client_config.current.subscription_id
  principal_type = {
    user                             = "User"
    group                            = "Group"
    app_registration                 = "ServicePrincipal"
    system_assigned_managed_identity = "ServicePrincipal"
    user_assigned_managed_identity   = "ServicePrincipal"
  }
}
