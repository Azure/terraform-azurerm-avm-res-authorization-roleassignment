variable "role_assignments_azure_resource_manager" {
  type = map(object({
    role_definition_id                     = optional(string)
    role_definition_name                   = optional(string)
    principal_type                         = optional(string)
    principal_id                           = string
    scope                                  = string
    condition                              = optional(string)
    condition_version                      = optional(string)
    delegated_managed_identity_resource_id = optional(string)
    description                            = optional(string)
  }))
  default     = {}
  description = <<DESCRIPTION
Basic Azure Resource Manager role assignments to create. This variable does not do any validation that principals or roles exist and you need to supply the principalID, scope, and roleDefinitionID or roleDefinitionName yourself.
The key is something unique to you. The value is a map of role assignment attributes.

- `role_definition_id` - (Optional) The ID of the role definition to assign.
- `role_definition_name` - (Optional) The name of the role definition to assign.
- `principal_type` - (Optional) The type of principal to assign the role to. Possible values are `User`, `Group`, `ServicePrincipal`, `SystemAssignedManagedIdentity`, `UserAssignedManagedIdentity`.
- `principal_id` - The ID of the principal to assign the role to.
- `scope` - The scope at which the role assignment applies.
- `condition` - (Optional) The condition under which the role assignment is active.
- `condition_version` - (Optional) The version of the condition.
- `delegated_managed_identity_resource_id` - (Optional) The resource ID of the delegated managed identity.
- `description` - (Optional) The description of the role assignment.
DESCRIPTION
}

variable "role_assignments_entra_id" {
  type = map(object({
    app_scope_id        = optional(string)
    directory_scope_id  = optional(string)
    principal_object_id = string
    role_id             = string
  }))
  default     = {}
  description = <<DESCRIPTION
Azure AD role assignments to create for Entra ID. This variable does not do any validation that principals or roles exist and you need to supply the principalObjectID and roleID yourself.

- `app_scope_id` - (Optional) The scope ID of the app.
- `directory_scope_id` - (Optional) The scope ID of the directory.
- `principal_object_id` - The object ID of the principal to assign the role to.
- `role_id` - The ID of the role to assign.
DESCRIPTION
}
