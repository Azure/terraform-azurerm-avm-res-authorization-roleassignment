variable "role_assignments_for_scopes" {
  type = map(object({
    scope = string
    role_assignments = map(object({
      role_definition                    = string
      users                              = optional(set(string), [])
      groups                             = optional(set(string), [])
      app_registrations                  = optional(set(string), [])
      system_assigned_managed_identities = optional(set(string), [])
      user_assigned_managed_identities   = optional(set(string), [])
      any_principals                     = optional(set(string), [])
    }))
  }))
  default = {}
}

# NOTE: Only supports provider subscription
variable "role_assignments_for_resources" {
  type = map(object({
    resource_name       = string
    resource_group_name = string
    role_assignments = map(object({
      role_definition                    = string
      users                              = optional(set(string), [])
      groups                             = optional(set(string), [])
      app_registrations                  = optional(set(string), [])
      system_assigned_managed_identities = optional(set(string), [])
      user_assigned_managed_identities   = optional(set(string), [])
      any_principals                     = optional(set(string), [])
    }))
  }))
  default = {}
}

variable "role_assignments_for_resource_groups" {
  type = map(object({
    resource_group_name = string
    subscription_id     = optional(string, null)
    role_assignments = map(object({
      role_definition                    = string
      users                              = optional(set(string), [])
      groups                             = optional(set(string), [])
      app_registrations                  = optional(set(string), [])
      system_assigned_managed_identities = optional(set(string), [])
      user_assigned_managed_identities   = optional(set(string), [])
      any_principals                     = optional(set(string), [])
    }))
  }))
  default = {}
}

variable "role_assignments_for_subscriptions" {
  type = map(object({
    subscription_id = optional(string, null)
    role_assignments = map(object({
      role_definition                    = string
      users                              = optional(set(string), [])
      groups                             = optional(set(string), [])
      app_registrations                  = optional(set(string), [])
      system_assigned_managed_identities = optional(set(string), [])
      user_assigned_managed_identities   = optional(set(string), [])
      any_principals                     = optional(set(string), [])
    }))
  }))
  default = {}
}

variable "role_assignments_for_management_groups" {
  type = map(object({
    management_group_id           = optional(string, null)
    management_group_display_name = optional(string, null)
    role_assignments = map(object({
      role_definition                    = string
      users                              = optional(set(string), [])
      groups                             = optional(set(string), [])
      app_registrations                  = optional(set(string), [])
      system_assigned_managed_identities = optional(set(string), [])
      user_assigned_managed_identities   = optional(set(string), [])
      any_principals                     = optional(set(string), [])
    }))
  }))
  default = {}
}

variable "role_assignments_for_entra_id" {
  type = map(object({
    role_assignments = map(object({
      role_definition                    = string
      users                              = optional(set(string), [])
      groups                             = optional(set(string), [])
      app_registrations                  = optional(set(string), [])
      system_assigned_managed_identities = optional(set(string), [])
      user_assigned_managed_identities   = optional(set(string), [])
      any_principals                     = optional(set(string), [])
    }))
  }))
  default = {}
}
