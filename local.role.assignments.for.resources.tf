locals {
  resource_role_definition_id_prefix = "/subscriptions/${data.azurerm_client_config.current.subscription_id}"
  role_assignments_for_resource_for_any = {
    for flattened_role_assignments in flatten([
      for key, value in var.role_assignments_for_resources : [
        for assignment_key, assignment_value in value.role_assignments : [
          for any_principal in assignment_value.any_principals : {
            key                = "resource-any-${key}-${assignment_key}-${any_principal}"
            role_definition_id = "${local.resource_role_definition_id_prefix}${local.role_definitions[assignment_value.role_definition].id}"
            principal_id       = local.all_principals[any_principal].principal_id
            scope              = data.azurerm_resources.resources_by_resource_group_and_name[key].resources[0].id
          }
        ]
      ]
    ]) : flattened_role_assignments.key => flattened_role_assignments
  }
  role_assignments_for_resource_for_app_registrations = {
    for flattened_role_assignments in flatten([
      for key, value in var.role_assignments_for_resources : [
        for assignment_key, assignment_value in value.role_assignments : [
          for app_registration in assignment_value.app_registrations : {
            key                = "resource-appregistration-${key}-${assignment_key}-${app_registration}"
            role_definition_id = "${local.resource_role_definition_id_prefix}${local.role_definitions[assignment_value.role_definition].id}"
            principal_id       = local.app_registrations[app_registration]
            scope              = data.azurerm_resources.resources_by_resource_group_and_name[key].resources[0].id
          }
        ]
      ]
    ]) : flattened_role_assignments.key => flattened_role_assignments
  }
  role_assignments_for_resource_for_groups = {
    for flattened_role_assignments in flatten([
      for key, value in var.role_assignments_for_resources : [
        for assignment_key, assignment_value in value.role_assignments : [
          for group in assignment_value.groups : {
            key                = "resource-group-${key}-${assignment_key}-${group}"
            role_definition_id = "${local.resource_role_definition_id_prefix}${local.role_definitions[assignment_value.role_definition].id}"
            principal_id       = local.groups[group]
            scope              = data.azurerm_resources.resources_by_resource_group_and_name[key].resources[0].id
          }
        ]
      ]
    ]) : flattened_role_assignments.key => flattened_role_assignments
  }
  role_assignments_for_resource_for_system_assigned_managed_identities = {
    for flattened_role_assignments in flatten([
      for key, value in var.role_assignments_for_resources : [
        for assignment_key, assignment_value in value.role_assignments : [
          for system_assigned_managed_identity in assignment_value.system_assigned_managed_identities : {
            key                = "resource-sami-${key}-${assignment_key}-${system_assigned_managed_identity}"
            role_definition_id = "${local.resource_role_definition_id_prefix}${local.role_definitions[assignment_value.role_definition].id}"
            principal_id       = local.system_assigned_managed_identities[system_assigned_managed_identity]
            scope              = data.azurerm_resources.resources_by_resource_group_and_name[key].resources[0].id
          }
        ]
      ]
    ]) : flattened_role_assignments.key => flattened_role_assignments
  }
  role_assignments_for_resource_for_user_assigned_managed_identities = {
    for flattened_role_assignments in flatten([
      for key, value in var.role_assignments_for_resources : [
        for assignment_key, assignment_value in value.role_assignments : [
          for user_assigned_managed_identity in assignment_value.user_assigned_managed_identities : {
            key                = "resource-uami-${key}-${assignment_key}-${user_assigned_managed_identity}"
            role_definition_id = "${local.resource_role_definition_id_prefix}${local.role_definitions[assignment_value.role_definition].id}"
            principal_id       = local.user_assigned_managed_identities[user_assigned_managed_identity]
            scope              = data.azurerm_resources.resources_by_resource_group_and_name[key].resources[0].id
          }
        ]
      ]
    ]) : flattened_role_assignments.key => flattened_role_assignments
  }
  role_assignments_for_resource_for_users = {
    for flattened_role_assignments in flatten([
      for key, value in var.role_assignments_for_resources : [
        for assignment_key, assignment_value in value.role_assignments : [
          for user in assignment_value.users : {
            key                = "resource-user-${key}-${assignment_key}-${user}"
            role_definition_id = "${local.resource_role_definition_id_prefix}${local.role_definitions[assignment_value.role_definition].id}"
            principal_id       = local.users[user]
            scope              = data.azurerm_resources.resources_by_resource_group_and_name[key].resources[0].id
          }
        ]
      ]
    ]) : flattened_role_assignments.key => flattened_role_assignments
  }
  role_assignments_for_resources = merge(
    local.role_assignments_for_resource_for_users,
    local.role_assignments_for_resource_for_groups,
    local.role_assignments_for_resource_for_app_registrations,
    local.role_assignments_for_resource_for_system_assigned_managed_identities,
    local.role_assignments_for_resource_for_user_assigned_managed_identities,
    local.role_assignments_for_resource_for_any
  )
}

data "azurerm_resources" "resources_by_resource_group_and_name" {
  for_each = var.role_assignments_for_resources

  name                = each.value.resource_name
  resource_group_name = each.value.resource_group_name
}
