resource "azurerm_role_assignment" "this" {
  for_each = local.role_assignments

  principal_id                     = each.value.principal_id
  scope                            = each.value.scope
  principal_type                   = each.value.principal_type
  role_definition_id               = each.value.role_definition_id
  skip_service_principal_aad_check = each.value.skip_service_principal_aad_check
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
  principal_type                         = each.value.principal_type
  role_definition_id                     = each.value.role_definition_id
  role_definition_name                   = each.value.role_definition_name
  skip_service_principal_aad_check       = each.value.skip_service_principal_aad_check
}

resource "azuread_directory_role_assignment" "basic" {
  for_each = var.role_assignments_entra_id

  principal_object_id = each.value.principal_object_id
  role_id             = each.value.role_id
  app_scope_id        = each.value.app_scope_id
  directory_scope_id  = each.value.directory_scope_id
}
