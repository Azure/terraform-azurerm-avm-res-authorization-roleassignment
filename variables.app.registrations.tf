variable "app_registrations_by_display_name" {
  type    = map(string)
  default = {}
}

variable "app_registrations_by_client_id" {
  type    = map(string)
  default = {}
}

variable "app_registrations_by_object_id" {
  type    = map(string)
  default = {}
}

variable "app_registrations_by_principal_id" {
  type    = map(string)
  default = {}
}
