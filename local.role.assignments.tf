locals {
  role_assignments = merge(
    local.role_assignments_by_resource,
    local.role_assignments_by_resource_group
  )
}
