output "all_principals" {
  description = "All principals"
  value       = module.role_assignments.all_principals
}

output "app_registrations" {
  description = "Entra ID application registrations"
  value       = module.role_assignments.app_registrations
}

output "entra_id_role_assignments" {
  description = "Entra ID role assignments"
  value       = module.role_assignments.entra_id_role_assignments
}

output "entra_id_role_definitions" {
  description = "Entra ID role definitions"
  value       = module.role_assignments.entra_id_role_definitions
}

output "groups" {
  description = "Entra ID groups"
  value       = module.role_assignments.groups
}

output "role_assignments" {
  description = "Azure Resource Manager role assignments"
  value       = module.role_assignments.role_assignments
}

output "role_definitions" {
  description = "Azure Resource Manager role definitions"
  value       = module.role_assignments.role_definitions
}

output "system_assigned_managed_identities" {
  description = "System assigned managed identities"
  value       = module.role_assignments.system_assigned_managed_identities
}

output "test_resource_ids" {
  description = "Test resource ids"
  value = {
    management_group = azurerm_management_group.test.id
    subscription     = "/subscriptions/${var.alternative_subscription_id}"
    resource_group   = azurerm_resource_group.test.id
    resource         = azurerm_static_web_app.test[local.system_assigned_managed_identities.sami1].id
  }
}

output "user_assigned_managed_identities" {
  description = "User assigned managed identities"
  value       = module.role_assignments.user_assigned_managed_identities
}

output "users" {
  description = "Entra ID users"
  value       = module.role_assignments.users
}
