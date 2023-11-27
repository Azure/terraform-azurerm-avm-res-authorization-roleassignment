variable "users_by_user_principal_name" {
  type    = map(string)
  default = {}
}

variable "users_by_mail" {
  type    = map(string)
  default = {}
}

variable "users_by_mail_nickname" {
  type    = map(string)
  default = {}
}

variable "users_by_employee_id" {
  type    = map(string)
  default = {}
}

variable "users_by_object_id" {
  type    = map(string)
  default = {}
}
