locals {
  system_assigned_managed_identities = merge(
    local.system_assigned_managed_identities_by_display_name,
    local.system_assigned_managed_identities_by_client_id,
    local.system_assigned_managed_identities_by_principal_id
  )
  system_assigned_managed_identities_by_client_id = { for key, value in data.azuread_service_principal.system_assigned_managed_identities_by_client_id :
    key => value.object_id
  }
  system_assigned_managed_identities_by_display_name = { for key, value in data.azuread_service_principal.system_assigned_managed_identities_by_display_name :
    key => value.object_id
  }
  system_assigned_managed_identities_by_principal_id = { for key, value in data.azuread_service_principal.system_assigned_managed_identities_by_principal_id :
    key => value.object_id
  }
}

data "azuread_service_principal" "system_assigned_managed_identities_by_display_name" {
  for_each = var.system_assigned_managed_identities_by_display_name

  display_name = each.value
}

data "azuread_service_principal" "system_assigned_managed_identities_by_client_id" {
  for_each = var.system_assigned_managed_identities_by_client_id

  client_id = each.value
}

data "azuread_service_principal" "system_assigned_managed_identities_by_principal_id" {
  for_each = var.system_assigned_managed_identities_by_principal_id

  object_id = each.value
}



