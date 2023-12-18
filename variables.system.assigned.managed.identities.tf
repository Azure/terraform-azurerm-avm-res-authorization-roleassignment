variable "system_assigned_managed_identities_by_display_name" {
  type        = map(string)
  default     = {}
  description = <<DESCRIPTION
  (Optional) A map of system assigned managed identities to reference in role assignments.
  The key is something unique to you. The value is the display name of the identity / compute instance.
DESCRIPTION
}

variable "system_assigned_managed_identities_by_client_id" {
  type        = map(string)
  default     = {}
  description = <<DESCRIPTION
  (Optional) A map of system assigned managed identities to reference in role assignments.
  The key is something unique to you. The value is the client id of the identity.
DESCRIPTION
}

variable "system_assigned_managed_identities_by_principal_id" {
  type        = map(string)
  default     = {}
  description = <<DESCRIPTION
  (Optional) A map of system assigned managed identities to reference in role assignments.
  The key is something unique to you. The value is the principal id of the underying service principalk of the identity.
DESCRIPTION
}
