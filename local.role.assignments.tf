locals {
  entra_id_role_assignments = merge(
    local.role_assignments_for_entra_id
  )
  role_assignments = merge(
    local.role_assignments_for_resources,
    local.role_assignments_for_resource_groups,
    local.role_assignments_for_subscriptions,
    local.role_assignments_for_management_groups,
    local.role_assignments_for_scopes
  )
  role_assignments_all = merge(
    local.role_assignments,
    local.role_assignments_azure_resource_manager_normalized
  )
  role_assignments_all_normalized = {
    for key, value in local.role_assignments_all :
    key => merge(
      {
        condition                              = null
        condition_version                      = null
        delegated_managed_identity_resource_id = null
        description                            = null
        principal_type                         = null
        skip_service_principal_aad_check       = false
      },
      value
    )
  }
}
