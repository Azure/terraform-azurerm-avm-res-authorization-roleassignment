locals {
  role_assignments_for_entra_id = merge(
    local.role_assignments_for_entra_id_for_users,
    local.role_assignments_for_entra_id_for_groups,
    local.role_assignments_for_entra_id_for_app_registrations,
    local.role_assignments_for_entra_id_for_system_assigned_managed_identities,
    local.role_assignments_for_entra_id_for_user_assigned_managed_identities,
    local.role_assignments_for_entra_id_for_any
  )
  role_assignments_for_entra_id_for_any = {
    for flattened_role_assignments in flatten([
      for key, value in var.role_assignments_for_entra_id : [
        for assignment_key, assignment_value in value.role_assignments : [
          for any_principal in assignment_value.any_principals : {
            key                = "entraid-any-${key}-${assignment_key}-${any_principal}"
            role_definition_id = local.entra_id_role_definitions[assignment_value.role_definition].id
            principal_id       = local.all_principals[any_principal].principal_id
          }
        ]
      ]
    ]) : flattened_role_assignments.key => flattened_role_assignments
  }
  role_assignments_for_entra_id_for_app_registrations = {
    for flattened_role_assignments in flatten([
      for key, value in var.role_assignments_for_entra_id : [
        for assignment_key, assignment_value in value.role_assignments : [
          for app_registration in assignment_value.app_registrations : {
            key                = "entraid-appregistration-${key}-${assignment_key}-${app_registration}"
            role_definition_id = local.entra_id_role_definitions[assignment_value.role_definition].id
            principal_id       = local.app_registrations[app_registration]
          }
        ]
      ]
    ]) : flattened_role_assignments.key => flattened_role_assignments
  }
  role_assignments_for_entra_id_for_groups = {
    for flattened_role_assignments in flatten([
      for key, value in var.role_assignments_for_entra_id : [
        for assignment_key, assignment_value in value.role_assignments : [
          for group in assignment_value.groups : {
            key                = "entraid-group-${key}-${assignment_key}-${group}"
            role_definition_id = local.entra_id_role_definitions[assignment_value.role_definition].id
            principal_id       = local.groups[group]
          }
        ]
      ]
    ]) : flattened_role_assignments.key => flattened_role_assignments
  }
  role_assignments_for_entra_id_for_system_assigned_managed_identities = {
    for flattened_role_assignments in flatten([
      for key, value in var.role_assignments_for_entra_id : [
        for assignment_key, assignment_value in value.role_assignments : [
          for system_assigned_managed_identity in assignment_value.system_assigned_managed_identities : {
            key                = "entraid-sami-${key}-${assignment_key}-${system_assigned_managed_identity}"
            role_definition_id = local.entra_id_role_definitions[assignment_value.role_definition].id
            principal_id       = local.system_assigned_managed_identities[system_assigned_managed_identity]
          }
        ]
      ]
    ]) : flattened_role_assignments.key => flattened_role_assignments
  }
  role_assignments_for_entra_id_for_user_assigned_managed_identities = {
    for flattened_role_assignments in flatten([
      for key, value in var.role_assignments_for_entra_id : [
        for assignment_key, assignment_value in value.role_assignments : [
          for user_assigned_managed_identity in assignment_value.user_assigned_managed_identities : {
            key                = "entraid-uami-${key}-${assignment_key}-${user_assigned_managed_identity}"
            role_definition_id = local.entra_id_role_definitions[assignment_value.role_definition].id
            principal_id       = local.user_assigned_managed_identities[user_assigned_managed_identity]
          }
        ]
      ]
    ]) : flattened_role_assignments.key => flattened_role_assignments
  }
  role_assignments_for_entra_id_for_users = {
    for flattened_role_assignments in flatten([
      for key, value in var.role_assignments_for_entra_id : [
        for assignment_key, assignment_value in value.role_assignments : [
          for user in assignment_value.users : {
            key                = "entraid-user-${key}-${assignment_key}-${user}"
            role_definition_id = local.entra_id_role_definitions[assignment_value.role_definition].id
            principal_id       = local.users[user]
          }
        ]
      ]
    ]) : flattened_role_assignments.key => flattened_role_assignments
  }
}
