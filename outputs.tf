output "users" {
  value = local.users
}

output "groups" {
  value = local.groups
}

output "app_registrations" {
  value = local.app_registrations
}

output "system_assigned_managed_identities" {
  value = local.system_assigned_managed_identities
}

output "user_assigned_managed_identities" {
  value = local.user_assigned_managed_identities
}

output "role_defintions" {
  value = local.role_definitions
}

output "role_assignments" {
  value = local.role_assignments
}

output "all_principals" {
  value = local.all_principals
}
