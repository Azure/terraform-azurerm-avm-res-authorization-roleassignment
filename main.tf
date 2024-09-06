resource "azurerm_role_assignment" "this" {
  for_each = local.role_assignments

  principal_id                     = each.value.principal_id
  scope                            = each.value.scope
  principal_type                   = each.value.principal_type
  role_definition_id               = each.value.role_definition_id
  skip_service_principal_aad_check = var.skip_service_principal_aad_check
}

resource "azuread_directory_role_assignment" "this" {
  for_each = local.entra_id_role_assignments

  principal_object_id = each.value.principal_id
  role_id             = each.value.role_definition_id
}
