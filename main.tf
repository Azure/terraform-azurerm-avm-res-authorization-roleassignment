moved {
  from = azurerm_role_assignment.this
  to   = azapi_resource.this
}

moved {
  from = azurerm_role_assignment.basic
  to   = azapi_resource.basic
}

resource "azapi_resource" "this" {
  for_each = local.role_assignments_normalized

  name      = uuidv5("11fb06fb-712d-4ddd-98c7-e71bbd588830", join("-", [each.value.scope, each.value.principal_id, each.value.role_definition_id]))
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
  ignore_body_changes = length(var.ignore_body_changes.authorization_role_assignments) > 0 ? var.ignore_body_changes.authorization_role_assignments : null
  replace_triggers_external_values = [
    each.value.principal_id,
    each.value.role_definition_id,
    each.value.principal_type,
    each.value.delegated_managed_identity_resource_id,
  ]
  replace_triggers_refs = [
    "properties.principalId",
    "properties.roleDefinitionId",
    "properties.principalType",
    "properties.delegatedManagedIdentityResourceId",
  ]
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

  lifecycle {
    ignore_changes = [name]
  }
}

resource "azapi_resource" "basic" {
  for_each = var.role_assignments_azure_resource_manager

  name      = uuidv5("11fb06fb-712d-4ddd-98c7-e71bbd588830", join("-", [each.value.scope, each.value.principal_id, local.role_assignments_azure_resource_manager_normalized["basic-${each.key}"].role_definition_id]))
  parent_id = each.value.scope
  type      = var.resource_types.authorization_role_assignments
  body = {
    properties = merge(
      {
        principalId      = each.value.principal_id
        roleDefinitionId = local.role_assignments_azure_resource_manager_normalized["basic-${each.key}"].role_definition_id
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
  ignore_body_changes = length(var.ignore_body_changes.authorization_role_assignments) > 0 ? var.ignore_body_changes.authorization_role_assignments : null
  replace_triggers_external_values = [
    each.value.principal_id,
    local.role_assignments_azure_resource_manager_normalized["basic-${each.key}"].role_definition_id,
    each.value.principal_type,
    each.value.delegated_managed_identity_resource_id,
  ]
  replace_triggers_refs = [
    "properties.principalId",
    "properties.roleDefinitionId",
    "properties.principalType",
    "properties.delegatedManagedIdentityResourceId",
  ]
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

  lifecycle {
    ignore_changes = [name]
  }
}

resource "azuread_directory_role_assignment" "this" {
  for_each = local.role_assignments_for_entra_id_without_legacy

  principal_object_id = each.value.principal_id
  role_id             = each.value.role_definition_id
}

resource "azuread_directory_role_assignment" "basic" {
  for_each = local.role_assignments_for_entra_id_legacy

  principal_object_id = each.value.principal_id
  role_id             = each.value.role_definition_id
  app_scope_id        = each.value.app_scope_id
  directory_scope_id  = each.value.directory_scope_id
}
