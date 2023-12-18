resource "azurerm_role_assignment" "this" {
  for_each           = local.role_assignments
  scope              = each.value.scope
  role_definition_id = each.value.role_definition_id
  principal_id       = each.value.principal_id
}

resource "azuread_directory_role_assignment" "this" {
  for_each = local.entra_id_role_assignments
  role_id             = each.value.role_definition_id
  principal_object_id = each.value.principal_id
}