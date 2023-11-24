variable "users" {
  type = map(object({
    user_principal_name = optional(string)
    mail                = optional(string)
    mail_nickname       = optional(string)
    employee_id         = optional(string)
    object_id           = optional(string)
  }))
  default = {}
}

variable "groups" {
  type = map(object({
    display_name = optional(string)
    mail         = optional(string)
    mail_nickname = optional(string)
    object_id    = optional(string)
  }))
  default = {}
}

variable "app_registrations" {
  type = map(object({
    display_name = optional(string)
    client_id = optional(string)
    object_id = optional(string)
    principal_id = optional(string)
  }))
  default = {}
}

variable "system_assigned_managed_identities" {
  type = map(object({
    display_name = optional(string)
    principal_id = optional(string)
    object_id    = optional(string)
  }))
  default = {}
}

variable "user_assigned_managed_identities" {
  type = map(object({
    resource_group_and_name = optional(object({
      resource_group_name = string
      name                = string
    }))
    display_name = optional(string)
    principal_id = optional(string)
    object_id    = optional(string)
  }))
  default = {}
}

variable "role_definitions" {
  type = map(string)
  default = {}
}

variable "resources" {
  type = map(object({
    resource_name       = string
    resource_group_name = string
    subscription_id     = string
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

variable "resource_groups" {
  type = map(object({
    resource_group_name = string
    subscription_id     = string
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
    subscription_id = string
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

variable "enable_telemetry" {
  type        = bool
  default     = true
  description = <<DESCRIPTION
This variable controls whether or not telemetry is enabled for the module.
For more information see https://aka.ms/avm/telemetryinfo.
If it is set to false, then no telemetry will be collected.
DESCRIPTION
}

variable "telemetry_resource_group_name" {
  type        = string
  description = "The resource group where the telemetry will be deployed."
  default     = ""
}
