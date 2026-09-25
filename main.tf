resource "azapi_resource" "this" {
  for_each = local.role_assignments_all_normalized

  name      = uuidv5("00000000-0000-0000-0000-000000000000", "${each.value.scope}|${each.value.principal_id}|${each.value.role_definition_id}")
  parent_id = each.value.scope
  type      = var.resource_types.authorization_role_assignments
  body = {
    properties = merge(
      {
        principalId      = each.value.principal_id
        roleDefinitionId = each.value.role_definition_id
      },
      each.value.principal_type == null ? {} : {
        principalType = each.value.principal_type
      },
      each.value.condition == null ? {} : {
        condition = each.value.condition
      },
      each.value.condition_version == null ? {} : {
        conditionVersion = each.value.condition_version
      },
      each.value.delegated_managed_identity_resource_id == null ? {} : {
        delegatedManagedIdentityResourceId = each.value.delegated_managed_identity_resource_id
      },
      each.value.description == null ? {} : {
        description = each.value.description
      }
    )
  }
  ignore_body_changes    = length(var.ignore_body_changes.authorization_role_assignments) > 0 ? var.ignore_body_changes.authorization_role_assignments : null
  response_export_values = []
  retry                  = var.retry

  dynamic "timeouts" {
    for_each = var.timeouts == null ? [] : [var.timeouts]

    content {
      create = timeouts.value.create
      read   = timeouts.value.read
      update = timeouts.value.update
      delete = timeouts.value.delete
    }
  }
}

resource "azuread_directory_role_assignment" "this" {
  count = length(local.entra_id_role_assignments)

  principal_object_id = values(local.entra_id_role_assignments)[count.index].principal_id
  role_id             = values(local.entra_id_role_assignments)[count.index].role_definition_id
}
