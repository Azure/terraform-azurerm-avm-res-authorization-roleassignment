variable "user_assigned_managed_identities_by_resource_group_and_name" {
  type = map(object({
    resource_group_name = string
    name                = string
  }))
  default     = {}
  description = <<DESCRIPTION
  (Optional) A map of user assigned managed identities to reference in role assignments.
  The key is something unique to you. The values are:
  
  - resource_group_name: The name of the resource group the identity is in.
  - name: The name of the identity.
DESCRIPTION
}

variable "user_assigned_managed_identities_by_display_name" {
  type        = map(string)
  default     = {}
  description = <<DESCRIPTION
  (Optional) A map of system assigned managed identities to reference in role assignments.
  The key is something unique to you. The value is the display name of the identity.
DESCRIPTION
}

variable "user_assigned_managed_identities_by_client_id" {
  type        = map(string)
  default     = {}
  description = <<DESCRIPTION
  (Optional) A map of system assigned managed identities to reference in role assignments.
  The key is something unique to you. The value is the client id of the identity.
DESCRIPTION
}

variable "user_assigned_managed_identities_by_principal_id" {
  type        = map(string)
  default     = {}
  description = <<DESCRIPTION
  (Optional) A map of system assigned managed identities to reference in role assignments.
  The key is something unique to you. The value is the principal id of the underying service principalk of the identity.
DESCRIPTION
}
