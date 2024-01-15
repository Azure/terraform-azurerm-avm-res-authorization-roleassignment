output "all_principals" {
  value = module.role_assignments.all_principals
}

output "app_registrations" {
  value = module.role_assignments.app_registrations
}

output "entra_id_role_assignments" {
  value = module.role_assignments.entra_id_role_assignments
}

output "entra_id_role_definitions" {
  value = module.role_assignments.entra_id_role_definitions
}

output "groups" {
  value = module.role_assignments.groups
}

output "role_assignments" {
  value = module.role_assignments.role_assignments
}

output "role_defintions" {
  value = module.role_assignments.role_defintions
}

output "system_assigned_managed_identities" {
  value = module.role_assignments.system_assigned_managed_identities
}

output "test_resource_ids" {
  value = {
    management_group = azurerm_management_group.test.id
    subscription     = "/subscriptions/${var.alternative_subscription_id}"
    resource_group   = azurerm_resource_group.test.id
    resource         = azurerm_static_site.test[local.system_assigned_managed_identities.sami1].id
  }
}

output "user_assigned_managed_identities" {
  value = module.role_assignments.user_assigned_managed_identities
}

output "users" {
  value = module.role_assignments.users
}
