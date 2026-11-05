data "azurerm_client_config" "current" {}

# The Bicep/ARM role assignment name needs the role definition GUID, which a name-only assignment doesn't carry.
data "azurerm_role_definition" "role_assignments_azure_resource_manager_by_name" {
  for_each = { for key, value in var.role_assignments_azure_resource_manager : key => value if value.role_definition_id == null }

  name  = each.value.role_definition_name
  scope = each.value.scope
}
