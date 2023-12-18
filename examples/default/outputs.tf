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

output "all_principals" {
  value = module.avm-ptn-authorization-roleassignment.all_principals
}

output "role_defintions" {
  value = module.avm-ptn-authorization-roleassignment.role_defintions
}

output "role_assignments" {
  value = module.avm-ptn-authorization-roleassignment.role_assignments
}

output "entra_id_role_definitions" {
  value = module.avm-ptn-authorization-roleassignment.entra_id_role_definitions
}

output "entra_id_role_assignments" {
  value = module.avm-ptn-authorization-roleassignment.entra_id_role_assignments
}

output "test_resource_ids" {
  value = {
    management_group = azurerm_management_group.test.id
    subscription     = "/subscriptions/${var.alternative_subscription_id}"
    resource_group   = azurerm_resource_group.test.id
    resource         = azurerm_static_site.test[local.system_assigned_managed_identities.sami1].id
  }
}
