# tflint-ignore: terraform_unused_declarations
variable "role_assignments_entra_id" {
  type = map(object({
    app_scope_id        = optional(string)
    directory_scope_id  = optional(string)
    principal_object_id = string
    role_id             = string
  }))
  default     = {}
  description = <<DESCRIPTION
DEPRECATED: Please use `role_assignments_for_entra_id` instead.

(Optional) Role assignments to be applied to Entra ID using the legacy flat structure.
This variable is retained for backward compatibility and is translated into the
`role_assignments_for_entra_id` input internally.

- `app_scope_id` - (Optional) The scope ID of the app. This legacy field is ignored.
- `directory_scope_id` - (Optional) The scope ID of the directory. This legacy field is ignored.
- `principal_object_id` - The object ID of the principal to assign the role to.
- `role_id` - The ID of the role to assign.
DESCRIPTION
}

# tflint-ignore: terraform_unused_declarations
variable "skip_service_principal_aad_check" {
  type        = bool
  default     = false
  description = <<DESCRIPTION
DEPRECATED: Please use the new `skip_service_principal_aad_check` variable inside of the different `role_assignments` blocks.

(Optional) Skip the check for the service principal in Azure AD.
This is useful when the service principal is not yet created in Azure AD.
DESCRIPTION
}
