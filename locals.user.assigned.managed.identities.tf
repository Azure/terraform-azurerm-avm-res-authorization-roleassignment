locals {
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
  user_assigned_managed_identities_by_principal_id = { for key, value in data.azuread_service_principal.user_assigned_managed_identities_by_principal_id :
    key => value.object_id
  }
  # Prepare the search criteria for system assigned managed identities
  user_assigned_managed_identities_by_resource_group_and_name = { for key, value in data.azurerm_user_assigned_identity.user_assigned_managed_identities_by_resource_group_and_name :
    key => value.principal_id
  }
}

data "azurerm_user_assigned_identity" "user_assigned_managed_identities_by_resource_group_and_name" {
  for_each = var.user_assigned_managed_identities_by_resource_group_and_name

  name                = each.value.name
  resource_group_name = each.value.resource_group_name
}

data "azuread_service_principal" "user_assigned_managed_identities_by_display_name" {
  for_each = var.user_assigned_managed_identities_by_display_name

  display_name = each.value
}

data "azuread_service_principal" "user_assigned_managed_identities_by_client_id" {
  for_each = var.user_assigned_managed_identities_by_client_id

  client_id = each.value
}

data "azuread_service_principal" "user_assigned_managed_identities_by_principal_id" {
  for_each = var.user_assigned_managed_identities_by_principal_id

  object_id = each.value
}



