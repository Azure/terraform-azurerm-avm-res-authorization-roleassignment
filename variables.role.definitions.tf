variable "role_definitions" {
  type        = map(string)
  default     = {}
  description = <<DESCRIPTION
(Optional) A map of Azure Resource Manager role definitions to reference in role assignments.
The key is something unique to you. The value is a built in or customer role definition name.
DESCRIPTION
}

variable "entra_id_role_definitions" {
  type        = map(string)
  default     = {}
  description = <<DESCRIPTION
(Optional) A map of Entra ID role definitions to reference in role assignments.
The key is something unique to you. The value is a built in or customer role definition name.
DESCRIPTION
}
