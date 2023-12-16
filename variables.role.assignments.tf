variable "role_assignments_by_scope" {
  type = map(object({
    scope = string
    role_assignments = map(object({
      role_definition                    = string
      users                              = optional(set(string))
      groups                             = optional(set(string))
      app_registrations                  = optional(set(string))
      system_assigned_managed_identities = optional(set(string))
      user_assigned_managed_identities   = optional(set(string))
    }))
  }))
  default = {}
}

# NOTE: Only supports provider subscription
variable "role_assignments_by_resource" {
  type = map(object({
    resource_name       = string
    resource_group_name = string
    role_assignments = map(object({
      role_definition                    = string
      users                              = optional(set(string))
      groups                             = optional(set(string))
      app_registrations                  = optional(set(string))
      system_assigned_managed_identities = optional(set(string))
      user_assigned_managed_identities   = optional(set(string))
    }))
  }))
  default = {}
}

variable "role_assignments_by_resource_group" {
  type = map(object({
    resource_group_name = string
    subscription_id     = optional(string, null)
    role_assignments = map(object({
      role_definition                    = string
      users                              = optional(set(string))
      groups                             = optional(set(string))
      app_registrations                  = optional(set(string))
      system_assigned_managed_identities = optional(set(string))
      user_assigned_managed_identities   = optional(set(string))
    }))
  }))
  default = {}
}

variable "subscriptions" {
  type = map(object({
    subscription_id = optional(string, null)
    role_assignments = map(object({
      role_definition                    = string
      users                              = optional(set(string))
      groups                             = optional(set(string))
      app_registrations                  = optional(set(string))
      system_assigned_managed_identities = optional(set(string))
      user_assigned_managed_identities   = optional(set(string))
    }))
  }))
  default = {}
}

variable "management_groups" {
  type = map(object({
    management_group_id = string
    role_assignments = map(object({
      role_definition                    = string
      users                              = optional(set(string))
      groups                             = optional(set(string))
      app_registrations                  = optional(set(string))
      system_assigned_managed_identities = optional(set(string))
      user_assigned_managed_identities   = optional(set(string))
    }))
  }))
  default = {}
}

variable "entra_id" {
  type = map(object({
    entra_id_tentant_id = string
    role_assignments = map(object({
      role_definition                    = string
      users                              = optional(set(string))
      groups                             = optional(set(string))
      app_registrations                  = optional(set(string))
      system_assigned_managed_identities = optional(set(string))
      user_assigned_managed_identities   = optional(set(string))
    }))
  }))
  default = {}
}
