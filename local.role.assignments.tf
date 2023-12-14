locals {
  role_assignments = merge(
    local.role_assignments_by_resource
  )
}
