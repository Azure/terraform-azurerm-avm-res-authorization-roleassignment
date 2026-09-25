locals {
  management_group_display_name_lookups = {
    for key, value in var.role_assignments_for_management_groups :
    key => value
    if value.management_group_id == null && value.management_group_display_name != null
  }
}

data "azapi_resource_list" "management_groups" {
  count = length(local.management_group_display_name_lookups) > 0 ? 1 : 0

  parent_id              = "/"
  type                   = "Microsoft.Management/managementGroups@2023-04-01"
  response_export_values = []
}

locals {
  management_groups_by_display_name = length(data.azapi_resource_list.management_groups) == 0 ? {} : {
    for management_group in one(data.azapi_resource_list.management_groups[*].output) :
    management_group.properties.displayName => management_group.id
  }
  management_groups = {
    for key, value in var.role_assignments_for_management_groups :
    key => value.management_group_id != null ? (
      startswith(value.management_group_id, "/") ? value.management_group_id : "/providers/Microsoft.Management/managementGroups/${value.management_group_id}"
    ) : local.management_groups_by_display_name[value.management_group_display_name]
  }
  role_assignments_for_management_groups_for_any = {
    for flattened_role_assignments in flatten([
      for key, value in var.role_assignments_for_management_groups : [
        for assignment_key, assignment_value in value.role_assignments : [
          for any_principal in assignment_value.any_principals : {
            key                              = "managementgroup-any-${key}-${assignment_key}-${any_principal}"
            role_definition_id               = local.role_definitions[assignment_value.role_definition].id
            principal_id                     = local.all_principals[any_principal].principal_id
            scope                            = local.management_groups[key]
            principal_type                   = null
            skip_service_principal_aad_check = false
          }
        ]
      ]
    ]) : flattened_role_assignments.key => flattened_role_assignments
  }
  role_assignments_for_management_groups_for_app_registrations = {
    for flattened_role_assignments in flatten([
      for key, value in var.role_assignments_for_management_groups : [
        for assignment_key, assignment_value in value.role_assignments : [
          for app_registration in assignment_value.app_registrations : {
            key                              = "managementgroup-appregistration-${key}-${assignment_key}-${app_registration}"
            role_definition_id               = local.role_definitions[assignment_value.role_definition].id
            principal_id                     = local.app_registrations[app_registration]
            scope                            = local.management_groups[key]
            principal_type                   = local.principal_type.app_registration
            skip_service_principal_aad_check = assignment_value.skip_service_principal_aad_check
          }
        ]
      ]
    ]) : flattened_role_assignments.key => flattened_role_assignments
  }
  role_assignments_for_management_groups_for_groups = {
    for flattened_role_assignments in flatten([
      for key, value in var.role_assignments_for_management_groups : [
        for assignment_key, assignment_value in value.role_assignments : [
          for group in assignment_value.groups : {
            key                              = "managementgroup-group-${key}-${assignment_key}-${group}"
            role_definition_id               = local.role_definitions[assignment_value.role_definition].id
            principal_id                     = local.groups[group]
            scope                            = local.management_groups[key]
            principal_type                   = local.principal_type.group
            skip_service_principal_aad_check = false
          }
        ]
      ]
    ]) : flattened_role_assignments.key => flattened_role_assignments
  }
  role_assignments_for_management_groups_for_system_assigned_managed_identities = {
    for flattened_role_assignments in flatten([
      for key, value in var.role_assignments_for_management_groups : [
        for assignment_key, assignment_value in value.role_assignments : [
          for system_assigned_managed_identity in assignment_value.system_assigned_managed_identities : {
            key                              = "managementgroup-sami-${key}-${assignment_key}-${system_assigned_managed_identity}"
            role_definition_id               = local.role_definitions[assignment_value.role_definition].id
            principal_id                     = local.system_assigned_managed_identities[system_assigned_managed_identity]
            scope                            = local.management_groups[key]
            principal_type                   = local.principal_type.system_assigned_managed_identity
            skip_service_principal_aad_check = assignment_value.skip_service_principal_aad_check
          }
        ]
      ]
    ]) : flattened_role_assignments.key => flattened_role_assignments
  }
  role_assignments_for_management_groups_for_user_assigned_managed_identities = {
    for flattened_role_assignments in flatten([
      for key, value in var.role_assignments_for_management_groups : [
        for assignment_key, assignment_value in value.role_assignments : [
          for user_assigned_managed_identity in assignment_value.user_assigned_managed_identities : {
            key                              = "managementgroup-uami-${key}-${assignment_key}-${user_assigned_managed_identity}"
            role_definition_id               = local.role_definitions[assignment_value.role_definition].id
            principal_id                     = local.user_assigned_managed_identities[user_assigned_managed_identity]
            scope                            = local.management_groups[key]
            principal_type                   = local.principal_type.user_assigned_managed_identity
            skip_service_principal_aad_check = assignment_value.skip_service_principal_aad_check
          }
        ]
      ]
    ]) : flattened_role_assignments.key => flattened_role_assignments
  }
  role_assignments_for_management_groups_for_users = {
    for flattened_role_assignments in flatten([
      for key, value in var.role_assignments_for_management_groups : [
        for assignment_key, assignment_value in value.role_assignments : [
          for user in assignment_value.users : {
            key                              = "managementgroup-user-${key}-${assignment_key}-${user}"
            role_definition_id               = local.role_definitions[assignment_value.role_definition].id
            principal_id                     = local.users[user]
            scope                            = local.management_groups[key]
            principal_type                   = local.principal_type.user
            skip_service_principal_aad_check = false
          }
        ]
      ]
    ]) : flattened_role_assignments.key => flattened_role_assignments
  }
  role_assignments_for_management_groups = merge(
    local.role_assignments_for_management_groups_for_users,
    local.role_assignments_for_management_groups_for_groups,
    local.role_assignments_for_management_groups_for_app_registrations,
    local.role_assignments_for_management_groups_for_system_assigned_managed_identities,
    local.role_assignments_for_management_groups_for_user_assigned_managed_identities,
    local.role_assignments_for_management_groups_for_any
  )
}
