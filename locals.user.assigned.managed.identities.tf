data "azapi_resource_list" "user_assigned_managed_identities_by_resource_group_and_name" {
  for_each = var.user_assigned_managed_identities_by_resource_group_and_name

  parent_id              = "/subscriptions/${data.azapi_client_config.current.subscription_id}/resourceGroups/${each.value.resource_group_name}"
  type                   = "Microsoft.ManagedIdentity/userAssignedIdentities@2024-11-30"
  response_export_values = []
}

data "azuread_service_principal" "user_assigned_managed_identities_by_display_name" {
  for_each = var.user_assigned_managed_identities_by_display_name

  display_name = each.value
}

data "azuread_service_principal" "user_assigned_managed_identities_by_client_id" {
  for_each = var.user_assigned_managed_identities_by_client_id

  client_id = each.value
}

locals {
  user_assigned_managed_identities_by_resource_group_and_name = {
    for key, value in data.azapi_resource_list.user_assigned_managed_identities_by_resource_group_and_name :
    key => one([
      for identity in value.output :
      try(identity.properties.principalId, null)
      if identity.name == var.user_assigned_managed_identities_by_resource_group_and_name[key].name
    ])
  }
  user_assigned_managed_identities = merge(
    local.user_assigned_managed_identities_by_resource_group_and_name,
    local.user_assigned_managed_identities_by_display_name,
    local.user_assigned_managed_identities_by_client_id,
    local.user_assigned_managed_identities_by_principal_id
  )
  user_assigned_managed_identities_by_client_id = { for key, value in data.azuread_service_principal.user_assigned_managed_identities_by_client_id :
    key => value.object_id
  }
  user_assigned_managed_identities_by_display_name = { for key, value in data.azuread_service_principal.user_assigned_managed_identities_by_display_name :
    key => value.object_id
  }
  user_assigned_managed_identities_by_principal_id = { for key, value in var.user_assigned_managed_identities_by_principal_id :
    key => value
  }
}
