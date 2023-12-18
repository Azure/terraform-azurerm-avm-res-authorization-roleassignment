variable "users_by_user_principal_name" {
  type        = map(string)
  default     = {}
  description = <<DESCRIPTION
  (Optional) A map of Entra ID users to reference in role assignments.
  The key is something unique to you. The value is the user principal name (UPN) of the user.
DESCRIPTION
}

variable "users_by_mail" {
  type        = map(string)
  default     = {}
  description = <<DESCRIPTION
  (Optional) A map of Entra ID users to reference in role assignments.
  The key is something unique to you. The value is the mail address of the user.
DESCRIPTION
}

variable "users_by_mail_nickname" {
  type        = map(string)
  default     = {}
  description = <<DESCRIPTION
  (Optional) A map of Entra ID users to reference in role assignments.
  The key is something unique to you. The value is the mail nickname of the user.
DESCRIPTION
}

variable "users_by_employee_id" {
  type        = map(string)
  default     = {}
  description = <<DESCRIPTION
  (Optional) A map of Entra ID users to reference in role assignments.
  The key is something unique to you. The value is the employee ID of the user.
DESCRIPTION
}

variable "users_by_object_id" {
  type        = map(string)
  default     = {}
  description = <<DESCRIPTION
  (Optional) A map of Entra ID users to reference in role assignments.
  The key is something unique to you. The value is the object ID of the user.
DESCRIPTION
}
