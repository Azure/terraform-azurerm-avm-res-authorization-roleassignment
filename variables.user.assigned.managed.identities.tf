variable "user_assigned_managed_identities_by_resource_group_and_name" {
  type = map(object({
    resource_group_name = string
    name                = string
  }))
  default = {}
}

variable "user_assigned_managed_identities_by_display_name" {
  type    = map(string)
  default = {}
}

variable "user_assigned_managed_identities_by_client_id" {
  type    = map(string)
  default = {}
}

variable "user_assigned_managed_identities_by_principal_id" {
  type    = map(string)
  default = {}
}
