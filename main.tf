resource "azurerm_role_assignment" "this" {
  for_each = local.role_assignments

  principal_id                     = each.value.principal_id
  scope                            = each.value.scope
  name                             = uuidv5("11fb06fb-712d-4ddd-98c7-e71bbd588830", join("-", [replace(lower(each.value.scope), "/(.)/+$/", "$1"), lower(each.value.principal_id), lower(basename(each.value.role_definition_id))]))
  principal_type                   = each.value.principal_type
  role_definition_id               = each.value.role_definition_id
  skip_service_principal_aad_check = each.value.skip_service_principal_aad_check

  lifecycle {
    ignore_changes = [name]
  }
}

resource "azuread_directory_role_assignment" "this" {
  for_each = local.entra_id_role_assignments

  principal_object_id = each.value.principal_id
  role_id             = each.value.role_definition_id
}

resource "azurerm_role_assignment" "basic" {
  for_each = var.role_assignments_azure_resource_manager

  principal_id                           = each.value.principal_id
  scope                                  = each.value.scope
  condition                              = each.value.condition
  condition_version                      = each.value.condition_version
  delegated_managed_identity_resource_id = each.value.delegated_managed_identity_resource_id
  description                            = each.value.description
  name                                   = uuidv5("11fb06fb-712d-4ddd-98c7-e71bbd588830", join("-", [replace(lower(each.value.scope), "/(.)/+$/", "$1"), lower(each.value.principal_id), lower(basename(coalesce(each.value.role_definition_id, try(data.azurerm_role_definition.role_assignments_azure_resource_manager_by_name[each.key].id, null))))]))
  principal_type                         = each.value.principal_type
  role_definition_id                     = each.value.role_definition_id
  role_definition_name                   = each.value.role_definition_name
  skip_service_principal_aad_check       = each.value.skip_service_principal_aad_check

  lifecycle {
    ignore_changes = [name]
  }
}

resource "azuread_directory_role_assignment" "basic" {
  for_each = var.role_assignments_entra_id

  principal_object_id = each.value.principal_object_id
  role_id             = each.value.role_id
  app_scope_id        = each.value.app_scope_id
  directory_scope_id  = each.value.directory_scope_id
}
