variable "role_assignment_by_scope" {
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
