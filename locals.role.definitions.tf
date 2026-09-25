locals {
  role_definition_parent_ids = {
    for key, value in var.role_definitions :
    key => coalesce(value.scope, "/subscriptions/${data.azapi_client_config.current.subscription_id}")
  }
}

data "azapi_resource_list" "role_definitions_by_name" {
  for_each = {
    for key, value in var.role_definitions :
    key => value
    if value.name != null && value.id == null
  }

  parent_id              = local.role_definition_parent_ids[each.key]
  type                   = "Microsoft.Authorization/roleDefinitions@2022-04-01"
  response_export_values = []
}

resource "azuread_directory_role" "entra_id_role_definitions_by_name" {
  for_each = var.entra_id_role_definitions

  display_name = each.value.display_name
  template_id  = each.value.template_id
}

locals {
  role_definitions = {
    for key, value in var.role_definitions :
    key => {
      id = value.id != null ? "${local.role_definition_parent_ids[key]}/providers/Microsoft.Authorization/roleDefinitions/${value.id}" : one([
        for role_definition in data.azapi_resource_list.role_definitions_by_name[key].output :
        role_definition.id
        if try(role_definition.properties.roleName, role_definition.name, null) == value.name
      ])
      scopes = value.id != null ? compact([
        value.scope
        ]) : one([
        for role_definition in data.azapi_resource_list.role_definitions_by_name[key].output :
        try(role_definition.properties.assignableScopes, [])
        if try(role_definition.properties.roleName, role_definition.name, null) == value.name
      ])
    }
  }

  entra_id_role_definitions = { for key, value in azuread_directory_role.entra_id_role_definitions_by_name :
    key => {
      id = value.template_id
    }
  }
}
