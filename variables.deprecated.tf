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
