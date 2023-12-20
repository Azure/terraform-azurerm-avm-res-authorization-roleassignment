locals {
  resource_group_role_definition_format = "/subscriptions/%s%s"
  resource_group_role_scope_format      = "/subscriptions/%s/resourceGroups/%s"
  role_assignments_for_resource_group_for_any = {
    for flattened_role_assignments in flatten([
      for key, value in var.role_assignments_for_resource_groups : [
        for assignment_key, assignment_value in value.role_assignments : [
          for any_principal in assignment_value.any_principals : {
            key                = "resourcegroup-any-${key}-${assignment_key}-${any_principal}"
            role_definition_id = format(local.resource_group_role_definition_format, value.subscription_id == null ? local.default_subscription_id : value.subscription_id, local.role_definitions[assignment_value.role_definition].id)
            principal_id       = local.all_principals[any_principal].principal_id
            scope              = format(local.resource_group_role_scope_format, value.subscription_id == null ? local.default_subscription_id : value.subscription_id, value.resource_group_name)
          }
        ]
      ]
    ]) : flattened_role_assignments.key => flattened_role_assignments
  }
  role_assignments_for_resource_group_for_app_registrations = {
    for flattened_role_assignments in flatten([
      for key, value in var.role_assignments_for_resource_groups : [
        for assignment_key, assignment_value in value.role_assignments : [
          for app_registration in assignment_value.app_registrations : {
            key                = "resourcegroup-appregistration-${key}-${assignment_key}-${app_registration}"
            role_definition_id = format(local.resource_group_role_definition_format, value.subscription_id == null ? local.default_subscription_id : value.subscription_id, local.role_definitions[assignment_value.role_definition].id)
            principal_id       = local.app_registrations[app_registration]
            scope              = format(local.resource_group_role_scope_format, value.subscription_id == null ? local.default_subscription_id : value.subscription_id, value.resource_group_name)
          }
        ]
      ]
    ]) : flattened_role_assignments.key => flattened_role_assignments
  }
  role_assignments_for_resource_group_for_groups = {
    for flattened_role_assignments in flatten([
      for key, value in var.role_assignments_for_resource_groups : [
        for assignment_key, assignment_value in value.role_assignments : [
          for group in assignment_value.groups : {
            key                = "resourcegroup-group-${key}-${assignment_key}-${group}"
            role_definition_id = format(local.resource_group_role_definition_format, value.subscription_id == null ? local.default_subscription_id : value.subscription_id, local.role_definitions[assignment_value.role_definition].id)
            principal_id       = local.groups[group]
            scope              = format(local.resource_group_role_scope_format, value.subscription_id == null ? local.default_subscription_id : value.subscription_id, value.resource_group_name)
          }
        ]
      ]
    ]) : flattened_role_assignments.key => flattened_role_assignments
  }
  role_assignments_for_resource_group_for_system_assigned_managed_identities = {
    for flattened_role_assignments in flatten([
      for key, value in var.role_assignments_for_resource_groups : [
        for assignment_key, assignment_value in value.role_assignments : [
          for system_assigned_managed_identity in assignment_value.system_assigned_managed_identities : {
            key                = "resourcegroup-sami-${key}-${assignment_key}-${system_assigned_managed_identity}"
            role_definition_id = format(local.resource_group_role_definition_format, value.subscription_id == null ? local.default_subscription_id : value.subscription_id, local.role_definitions[assignment_value.role_definition].id)
            principal_id       = local.system_assigned_managed_identities[system_assigned_managed_identity]
            scope              = format(local.resource_group_role_scope_format, value.subscription_id == null ? local.default_subscription_id : value.subscription_id, value.resource_group_name)
          }
        ]
      ]
    ]) : flattened_role_assignments.key => flattened_role_assignments
  }
  role_assignments_for_resource_group_for_user_assigned_managed_identities = {
    for flattened_role_assignments in flatten([
      for key, value in var.role_assignments_for_resource_groups : [
        for assignment_key, assignment_value in value.role_assignments : [
          for user_assigned_managed_identity in assignment_value.user_assigned_managed_identities : {
            key                = "resourcegroup-uami-${key}-${assignment_key}-${user_assigned_managed_identity}"
            role_definition_id = format(local.resource_group_role_definition_format, value.subscription_id == null ? local.default_subscription_id : value.subscription_id, local.role_definitions[assignment_value.role_definition].id)
            principal_id       = local.user_assigned_managed_identities[user_assigned_managed_identity]
            scope              = format(local.resource_group_role_scope_format, value.subscription_id == null ? local.default_subscription_id : value.subscription_id, value.resource_group_name)
          }
        ]
      ]
    ]) : flattened_role_assignments.key => flattened_role_assignments
  }
  role_assignments_for_resource_group_for_users = {
    for flattened_role_assignments in flatten([
      for key, value in var.role_assignments_for_resource_groups : [
        for assignment_key, assignment_value in value.role_assignments : [
          for user in assignment_value.users : {
            key                = "resourcegroup-user-${key}-${assignment_key}-${user}"
            role_definition_id = format(local.resource_group_role_definition_format, value.subscription_id == null ? local.default_subscription_id : value.subscription_id, local.role_definitions[assignment_value.role_definition].id)
            principal_id       = local.users[user]
            scope              = format(local.resource_group_role_scope_format, value.subscription_id == null ? local.default_subscription_id : value.subscription_id, value.resource_group_name)
          }
        ]
      ]
    ]) : flattened_role_assignments.key => flattened_role_assignments
  }
  role_assignments_for_resource_groups = merge(
    local.role_assignments_for_resource_group_for_users,
    local.role_assignments_for_resource_group_for_groups,
    local.role_assignments_for_resource_group_for_app_registrations,
    local.role_assignments_for_resource_group_for_system_assigned_managed_identities,
    local.role_assignments_for_resource_group_for_user_assigned_managed_identities,
    local.role_assignments_for_resource_group_for_any
  )
}
