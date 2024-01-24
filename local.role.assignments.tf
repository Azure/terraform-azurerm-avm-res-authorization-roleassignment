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
}
