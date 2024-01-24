resource "azurerm_role_assignment" "this" {
  for_each = local.role_assignments

  principal_id       = each.value.principal_id
  scope              = each.value.scope
  role_definition_id = each.value.role_definition_id
}

resource "azuread_directory_role_assignment" "this" {
  for_each = local.entra_id_role_assignments

  principal_object_id = each.value.principal_id
  role_id             = each.value.role_definition_id
}
