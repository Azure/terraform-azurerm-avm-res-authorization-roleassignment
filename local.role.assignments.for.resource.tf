locals {
  role_assignments_by_resource_for_users = {
    for flattened_role_assignments in distinct(flatten([
      for key, value in var.role_assignments_by_resource : [
        for assignment_key, assignment_value in value.role_assignments : [
          for user in assignment_value.users : {
            key                = "${key}-${assignment_key}-${user}"
            role_definition_id = local.role_definitions[assignment_value.role_definition]
            principal_id       = local.users[user]
            scope              = data.azurerm_resources.resources_by_resource_group_and_name[key].resources[0].id
          }
        ]
      ]
    ])) : flattened_role_assignments.key => flattened_role_assignments
  }

  role_assignments_by_resource_for_groups = {
    for flattened_role_assignments in distinct(flatten([
      for key, value in var.role_assignments_by_resource : [
        for assignment_key, assignment_value in value.role_assignments : [
          for group in assignment_value.groups : {
            key                = "${key}-${assignment_key}-${group}"
            role_definition_id = local.role_definitions[assignment_value.role_definition]
            principal_id       = local.groups[group]
            scope              = data.azurerm_resources.resources_by_resource_group_and_name[key].resources[0].id
          }
        ]
      ]
    ])) : flattened_role_assignments.key => flattened_role_assignments
  }

  role_assignments_by_resource_for_app_registrations = {
    for flattened_role_assignments in distinct(flatten([
      for key, value in var.role_assignments_by_resource : [
        for assignment_key, assignment_value in value.role_assignments : [
          for app_registration in assignment_value.app_registrations : {
            key                = "${key}-${assignment_key}-${app_registration}"
            role_definition_id = local.role_definitions[assignment_value.role_definition]
            principal_id       = local.app_registrations[app_registration]
            scope              = data.azurerm_resources.resources_by_resource_group_and_name[key].resources[0].id
          }
        ]
      ]
    ])) : flattened_role_assignments.key => flattened_role_assignments
  }

  role_assignments_by_resource_for_system_assigned_managed_identities = {
    for flattened_role_assignments in distinct(flatten([
      for key, value in var.role_assignments_by_resource : [
        for assignment_key, assignment_value in value.role_assignments : [
          for system_assigned_managed_identity in assignment_value.system_assigned_managed_identities : {
            key                = "${key}-${assignment_key}-${system_assigned_managed_identity}"
            role_definition_id = local.role_definitions[assignment_value.role_definition]
            principal_id       = local.system_assigned_managed_identities[system_assigned_managed_identity]
            scope              = data.azurerm_resources.resources_by_resource_group_and_name[key].resources[0].id
          }
        ]
      ]
    ])) : flattened_role_assignments.key => flattened_role_assignments
  }

  role_assignments_by_resource_for_user_assigned_managed_identities = {
    for flattened_role_assignments in distinct(flatten([
      for key, value in var.role_assignments_by_resource : [
        for assignment_key, assignment_value in value.role_assignments : [
          for user_assigned_managed_identity in assignment_value.user_assigned_managed_identities : {
            key                = "${key}-${assignment_key}-${user_assigned_managed_identity}"
            role_definition_id = local.role_definitions[assignment_value.role_definition]
            principal_id       = local.user_assigned_managed_identities[user_assigned_managed_identity]
            scope              = data.azurerm_resources.resources_by_resource_group_and_name[key].resources[0].id
          }
        ]
      ]
    ])) : flattened_role_assignments.key => flattened_role_assignments
  }

  role_assignments_by_resource = merge(
    local.role_assignments_by_resource_for_users,
    local.role_assignments_by_resource_for_groups,
    local.role_assignments_by_resource_for_app_registrations,
    local.role_assignments_by_resource_for_system_assigned_managed_identities,
    local.role_assignments_by_resource_for_user_assigned_managed_identities
  )
}

data "azurerm_resources" "resources_by_resource_group_and_name" {
  for_each            = var.role_assignments_by_resource
  resource_group_name = each.value.resource_group_name
  name                = each.value.resource_name
}
