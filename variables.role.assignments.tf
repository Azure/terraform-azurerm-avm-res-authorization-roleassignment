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
  default     = {}
  nullable    = false
  description = <<DESCRIPTION
(Optional) Role assignments to be applied to specific scope ids. The scope id is the id of the resource, resource group, subscription or management group.

- scope: (Required) The scope / id of the resource, resource group, subscription or management group.
- role_assignments: (Required) The role assignments to be applied to the scope.
  - role_definition: (Required) The key of the role definition as defined in the `role_definitions` variable.
  - users: (Optional) The keys of the users as defined in one of the `users_by_...` variables.
  - groups: (Optional) The keys of the groups as defined in one of the `groups_by_...` variables.
  - app_registrations: (Optional) The keys of the app registrations as defined in one of the `app_registrations_by_...` variables.
  - system_assigned_managed_identities: (Optional) The keys of the system assigned managed identities as defined in one of the `system_assigned_managed_identities_by_...` variables.
  - user_assigned_managed_identities: (Optional) The keys of the user assigned managed identities as defined in one of the `user_assigned_managed_identities_by_...` variables.
  - any_principals: (Optional) The keys of the principals as defined in any of the `[principal_type]_by_...` variables. This is a convenience method that can be used in combination with or instrad of the specific principal type options.

Example Input:

```hcl
role_assignments_for_scopes = {
  scope            = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-resource-group"
  role_assignments = {
    role_definition = "contributor"
    users = [
      "my-user-1",
      "my-user-2"
    ]
    groups = [
      "my-group-1",
      "my-group-2"
    ]
    app_registrations = [
      "my-app-1",
      "my-app-2"
    ]
    system_assigned_managed_identities = [
      "my-vm-1",
      "my-vm-2"
    ]
    user_assigned_managed_identities = [
      "my-user-assigned-managed-identity-1",
      "my-user-assigned-managed-identity-2"
    ]
  }
}
```
DESCRIPTION
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
  default     = {}
  nullable    = false
  description = <<DESCRIPTION
(Optional) Role assignments to be applied to resources. The resource is defined by the resource name and the resource group name.
This variable only works with the current provider subscription. This is a convenience variable that avoids the need to find the resource id.

- resouce_name: (Required) The names of the resource.
- resource_group_name: (Required) The name of the resource group.
- role_assignments: (Required) The role assignments to be applied to the scope.
  - role_definition: (Required) The key of the role definition as defined in the `role_definitions` variable.
  - users: (Optional) The keys of the users as defined in one of the `users_by_...` variables.
  - groups: (Optional) The keys of the groups as defined in one of the `groups_by_...` variables.
  - app_registrations: (Optional) The keys of the app registrations as defined in one of the `app_registrations_by_...` variables.
  - system_assigned_managed_identities: (Optional) The keys of the system assigned managed identities as defined in one of the `system_assigned_managed_identities_by_...` variables.
  - user_assigned_managed_identities: (Optional) The keys of the user assigned managed identities as defined in one of the `user_assigned_managed_identities_by_...` variables.
  - any_principals: (Optional) The keys of the principals as defined in any of the `[principal_type]_by_...` variables. This is a convenience method that can be used in combination with or instrad of the specific principal type options.

Example Input:

```hcl
role_assignments_for_resources = {
  resource_name       = "my-resource-name"
  resource_group_name = "my-resource-group-name"
  role_assignments    = {
    role_definition = "contributor"
    users = [
      "my-user-1",
      "my-user-2"
    ]
    groups = [
      "my-group-1",
      "my-group-2"
    ]
    app_registrations = [
      "my-app-1",
      "my-app-2"
    ]
    system_assigned_managed_identities = [
      "my-vm-1",
      "my-vm-2"
    ]
    user_assigned_managed_identities = [
      "my-user-assigned-managed-identity-1",
      "my-user-assigned-managed-identity-2"
    ]
  }
}
```
DESCRIPTION
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
  default     = {}
  nullable    = false
  description = <<DESCRIPTION
(Optional) Role assignments to be applied to resource groups.
The resource group can be in the current subscription (default) or a `subscription_id` can be supplied to target a resource group in another subscription.
This is a convenience variable that avoids the need to find the resource id of the resource group.

- resource_group_name: (Required) The name of the resource group.
- subscription_id: (Optional) The id of the subscription. If not supplied the current subscription is used.
- role_assignments: (Required) The role assignments to be applied to the scope.
  - role_definition: (Required) The key of the role definition as defined in the `role_definitions` variable.
  - users: (Optional) The keys of the users as defined in one of the `users_by_...` variables.
  - groups: (Optional) The keys of the groups as defined in one of the `groups_by_...` variables.
  - app_registrations: (Optional) The keys of the app registrations as defined in one of the `app_registrations_by_...` variables.
  - system_assigned_managed_identities: (Optional) The keys of the system assigned managed identities as defined in one of the `system_assigned_managed_identities_by_...` variables.
  - user_assigned_managed_identities: (Optional) The keys of the user assigned managed identities as defined in one of the `user_assigned_managed_identities_by_...` variables.
  - any_principals: (Optional) The keys of the principals as defined in any of the `[principal_type]_by_...` variables. This is a convenience method that can be used in combination with or instrad of the specific principal type options.

Example Input:

```hcl
role_assignments_for_resource_groups = {
  resource_group_name = "my-resource-group-name"
  role_assignments    = {
    role_definition = "contributor"
    users = [
      "my-user-1",
      "my-user-2"
    ]
    groups = [
      "my-group-1",
      "my-group-2"
    ]
    app_registrations = [
      "my-app-1",
      "my-app-2"
    ]
    system_assigned_managed_identities = [
      "my-vm-1",
      "my-vm-2"
    ]
    user_assigned_managed_identities = [
      "my-user-assigned-managed-identity-1",
      "my-user-assigned-managed-identity-2"
    ]
  }
}
```
DESCRIPTION
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
  default     = {}
  nullable    = false
  description = <<DESCRIPTION
(Optional) Role assignments to be applied to subscriptions.
This will default to the current subscription (default) or a `subscription_id` can be supplied to target another subscription.
This is a convenience variable that avoids the need to find the resource id of the subscription.

- subscription_id: (Optional) The id of the subscription. If not supplied the current subscription is used.
- role_assignments: (Required) The role assignments to be applied to the scope.
  - role_definition: (Required) The key of the role definition as defined in the `role_definitions` variable.
  - users: (Optional) The keys of the users as defined in one of the `users_by_...` variables.
  - groups: (Optional) The keys of the groups as defined in one of the `groups_by_...` variables.
  - app_registrations: (Optional) The keys of the app registrations as defined in one of the `app_registrations_by_...` variables.
  - system_assigned_managed_identities: (Optional) The keys of the system assigned managed identities as defined in one of the `system_assigned_managed_identities_by_...` variables.
  - user_assigned_managed_identities: (Optional) The keys of the user assigned managed identities as defined in one of the `user_assigned_managed_identities_by_...` variables.
  - any_principals: (Optional) The keys of the principals as defined in any of the `[principal_type]_by_...` variables. This is a convenience method that can be used in combination with or instrad of the specific principal type options.

Example Input:

```hcl
role_assignments_for_subscriptions = {
  subscription_id     = "00000000-0000-0000-0000-000000000000"
  role_assignments    = {
    role_definition = "contributor"
    users = [
      "my-user-1",
      "my-user-2"
    ]
    groups = [
      "my-group-1",
      "my-group-2"
    ]
    app_registrations = [
      "my-app-1",
      "my-app-2"
    ]
    system_assigned_managed_identities = [
      "my-vm-1",
      "my-vm-2"
    ]
    user_assigned_managed_identities = [
      "my-user-assigned-managed-identity-1",
      "my-user-assigned-managed-identity-2"
    ]
  }
}
```
DESCRIPTION
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
  default     = {}
  nullable    = false
  description = <<DESCRIPTION
(Optional) Role assignments to be applied to management groups.
This is a convenience variable that avoids the need to find the resource id of the management group.

- management_group_id: (Optional) The id of the management group (one of `management_group_id` or `management_group_display_name` must be supplied).
- management_group_display_name: (Optional) The display name of the management group.
- role_assignments: (Required) The role assignments to be applied to the scope.
  - role_definition: (Required) The key of the role definition as defined in the `role_definitions` variable.
  - users: (Optional) The keys of the users as defined in one of the `users_by_...` variables.
  - groups: (Optional) The keys of the groups as defined in one of the `groups_by_...` variables.
  - app_registrations: (Optional) The keys of the app registrations as defined in one of the `app_registrations_by_...` variables.
  - system_assigned_managed_identities: (Optional) The keys of the system assigned managed identities as defined in one of the `system_assigned_managed_identities_by_...` variables.
  - user_assigned_managed_identities: (Optional) The keys of the user assigned managed identities as defined in one of the `user_assigned_managed_identities_by_...` variables.
  - any_principals: (Optional) The keys of the principals as defined in any of the `[principal_type]_by_...` variables. This is a convenience method that can be used in combination with or instrad of the specific principal type options.

Example Input:

```hcl
role_assignments_for_management_groups = {
  management_group_id = "mg-1-id"
  role_assignments    = {
    role_definition = "contributor"
    users = [
      "my-user-1",
      "my-user-2"
    ]
    groups = [
      "my-group-1",
      "my-group-2"
    ]
    app_registrations = [
      "my-app-1",
      "my-app-2"
    ]
    system_assigned_managed_identities = [
      "my-vm-1",
      "my-vm-2"
    ]
    user_assigned_managed_identities = [
      "my-user-assigned-managed-identity-1",
      "my-user-assigned-managed-identity-2"
    ]
  }
}

role_assignments_for_management_groups = {
  management_group_display_name = "mg-1-display-name"
  role_assignments              = {
    role_definition = "contributor"
    users = [
      "my-user-1",
      "my-user-2"
    ]
    groups = [
      "my-group-1",
      "my-group-2"
    ]
    app_registrations = [
      "my-app-1",
      "my-app-2"
    ]
    system_assigned_managed_identities = [
      "my-vm-1",
      "my-vm-2"
    ]
    user_assigned_managed_identities = [
      "my-user-assigned-managed-identity-1",
      "my-user-assigned-managed-identity-2"
    ]
  }
}
```
DESCRIPTION
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
  default     = {}
  nullable    = false
  description = <<DESCRIPTION
(Optional) Role assignments to be applied to Entra ID.
This variable allows the assignment of Entra ID directory roles outside of the scope of Azure Resource Manager.
This variable requires the `entra_id_role_definitions` variable to be populated.

- role_assignments: (Required) The role assignments to be applied to the scope.
  - role_definition: (Required) The key of the role definition as defined in the `entra_id_role_definitions` variable.
  - users: (Optional) The keys of the users as defined in one of the `users_by_...` variables.
  - groups: (Optional) The keys of the groups as defined in one of the `groups_by_...` variables.
  - app_registrations: (Optional) The keys of the app registrations as defined in one of the `app_registrations_by_...` variables.
  - system_assigned_managed_identities: (Optional) The keys of the system assigned managed identities as defined in one of the `system_assigned_managed_identities_by_...` variables.
  - user_assigned_managed_identities: (Optional) The keys of the user assigned managed identities as defined in one of the `user_assigned_managed_identities_by_...` variables.
  - any_principals: (Optional) The keys of the principals as defined in any of the `[principal_type]_by_...` variables. This is a convenience method that can be used in combination with or instrad of the specific principal type options.

Example Input:

```hcl
role_assignments_for_entra_id = {
  role_assignments    = {
    role_definition = "directory-writer"
    users = [
      "my-user-1",
      "my-user-2"
    ]
    groups = [
      "my-group-1",
      "my-group-2"
    ]
    app_registrations = [
      "my-app-1",
      "my-app-2"
    ]
    system_assigned_managed_identities = [
      "my-vm-1",
      "my-vm-2"
    ]
    user_assigned_managed_identities = [
      "my-user-assigned-managed-identity-1",
      "my-user-assigned-managed-identity-2"
    ]
  }
}
```
DESCRIPTION
}
