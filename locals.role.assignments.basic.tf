locals {
  role_assignments_azure_resource_manager_role_definition_parent_ids = {
    for key, value in var.role_assignments_azure_resource_manager :
    key => length(regexall("^/providers/Microsoft.Management/managementGroups/[^/]+$", value.scope)) > 0 ? value.scope : "/subscriptions/${split("/", value.scope)[2]}"
  }
}

data "azapi_resource_list" "role_assignments_azure_resource_manager_role_definitions_by_name" {
  for_each = {
    for key, value in var.role_assignments_azure_resource_manager :
    key => value
    if value.role_definition_name != null && value.role_definition_id == null
  }

  parent_id              = local.role_assignments_azure_resource_manager_role_definition_parent_ids[each.key]
  type                   = "Microsoft.Authorization/roleDefinitions@2022-04-01"
  response_export_values = []
}

locals {
  role_assignments_azure_resource_manager_normalized = {
    for key, value in var.role_assignments_azure_resource_manager :
    "basic-${key}" => {
      condition                              = value.condition
      condition_version                      = value.condition_version
      delegated_managed_identity_resource_id = value.delegated_managed_identity_resource_id
      description                            = value.description
      principal_id                           = value.principal_id
      principal_type                         = value.principal_type
      role_definition_id = value.role_definition_id != null ? value.role_definition_id : one([
        for role_definition in data.azapi_resource_list.role_assignments_azure_resource_manager_role_definitions_by_name[key].output :
        role_definition.id
        if try(role_definition.properties.roleName, role_definition.name, null) == value.role_definition_name
      ])
      scope                            = value.scope
      skip_service_principal_aad_check = value.skip_service_principal_aad_check
    }
  }
}
