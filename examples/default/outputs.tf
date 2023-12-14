output "users" {
  value = module.avm-ptn-authorization-roleassignment.users
}

output "groups" {
  value = module.avm-ptn-authorization-roleassignment.groups
}

output "app_registrations" {
  value = module.avm-ptn-authorization-roleassignment.app_registrations
}

output "system_assigned_managed_identities" {
  value = module.avm-ptn-authorization-roleassignment.system_assigned_managed_identities
}

output "user_assigned_managed_identities" {
  value = module.avm-ptn-authorization-roleassignment.user_assigned_managed_identities
}
