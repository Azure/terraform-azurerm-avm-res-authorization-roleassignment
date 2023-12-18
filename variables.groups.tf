variable "groups_by_display_name" {
  type        = map(string)
  default     = {}
  description = <<DESCRIPTION
  (Optional) A map of Entra ID groups to reference in role assignments.
  The key is something unique to you. The value is the display name of the group.
DESCRIPTION
}

variable "groups_by_mail_nickname" {
  type        = map(string)
  default     = {}
  description = <<DESCRIPTION
  (Optional) A map of Entra ID groups to reference in role assignments.
  The key is something unique to you. The value is the mail nickname of the group.
DESCRIPTION
}

variable "groups_by_object_id" {
  type        = map(string)
  default     = {}
  description = <<DESCRIPTION
  (Optional) A map of Entra ID groups to reference in role assignments.
  The key is something unique to you. The value is the object ID of the group.
DESCRIPTION
}
