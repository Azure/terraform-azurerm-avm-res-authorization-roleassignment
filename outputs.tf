output "all_principals" {
  description = <<DESCRIPTION
A map of all principals. The key is the key you supplied and the value is the principal id (object id) of the user, group, service principal, or managed identity.
DESCRIPTION
  value       = local.all_principals
}

output "app_registrations" {
  description = "A map of Entra ID application registrations. The key is the key you supplied and the value is the principal id (object id) of the service principal backing the application registration."
  value       = local.app_registrations
}

output "entra_id_role_assignments" {
  description = <<DESCRIPTION
A map of Entra ID role assignments. The key is the key you supplied and the value is the role assignment details:

* `role_definition_id`: The role definition template id of the role assignment.
* `principal_id`: The principal id (object id) of the user, group, service principal, or managed identity the role assignment is for.
DESCRIPTION
  value       = local.entra_id_role_assignments
}

output "entra_id_role_definitions" {
  description = "A map of Entra ID role definitions. The key is the key you supplied and the value is the role definition template id."
  value       = local.entra_id_role_definitions
}

output "groups" {
  description = "A map of Entra ID groups. The key is the key you supplied and the value is the principal id (object id) of the group."
  value       = local.groups
}

output "resource_id" {
  description = "This output is not used and is only here to satisfy the requirements of the module linting."
  value       = null
}

output "role_assignments" {
  description = <<DESCRIPTION
A map of Azure Resource Manager role assignments. The key is the key you supplied and the value is the role assignment details:

* `role_definition_id`: The role definition id of the role assignment.
* `principal_id`: The principal id (object id) of the user, group, service principal, or managed identity the role assignment is for.
* `scope`: The scope of the role assignment.
DESCRIPTION
  value       = local.role_assignments
}

output "role_defintions" {
  description = "A map of Azure Resource Manager role definitions. The key is the key you supplied and the value consists of is the role definition id and the allowed scopes."
  value       = local.role_definitions
}

output "system_assigned_managed_identities" {
  description = "A map of system assigned managed identities. The key is the key you supplied and value is the principal id (object id) of the service principal backing system assigned managed identity."
  value       = local.system_assigned_managed_identities
}

output "user_assigned_managed_identities" {
  description = "A map of user assigned managed identities. The key is the key you supplied and value is the principal id (object id) of the service principal backing user assigned managed identity."
  value       = local.user_assigned_managed_identities
}

output "users" {
  description = "A map of Entra ID users. The key is the key you supplied and the value is the principal id (object id) of the user."
  value       = local.users
}
