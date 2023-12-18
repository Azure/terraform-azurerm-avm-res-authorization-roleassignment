locals {
  role_assignments = merge(
    local.role_assignments_for_resource,
    local.role_assignments_for_resource_group,
    local.role_assignments_for_subscription
  )
}
