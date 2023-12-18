locals {
  role_assignments = merge(
    local.role_assignments_for_resources,
    local.role_assignments_for_resource_groups,
    local.role_assignments_for_subscriptions,
    local.role_assignments_for_management_groups
  )
}
