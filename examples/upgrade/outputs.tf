output "role_assignments" {
  description = "Azure Resource Manager role assignments"
  value       = module.role_assignments.role_assignments
}
