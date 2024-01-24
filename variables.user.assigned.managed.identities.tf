variable "user_assigned_managed_identities_by_resource_group_and_name" {
  type = map(object({
    resource_group_name = string
    name                = string
  }))
  default     = {}
  nullable    = false
  description = <<DESCRIPTION
(Optional) A map of user assigned managed identities to reference in role assignments.
The key is something unique to you. The values are:

- resource_group_name: The name of the resource group the identity is in.
- name: The name of the identity.

Example Input:

```hcl
user_assigned_managed_identities_by_resource_group_and_name = {
  my-identity-1 = {
    resource_group_name = "my-rg-1"
    name                = "my-identity-1"
  }
  my-identity-2 = {
    resource_group_name = "my-rg-2"
    name                = "my-identity-2"
  }
}
```
DESCRIPTION
}

variable "user_assigned_managed_identities_by_display_name" {
  type        = map(string)
  default     = {}
  nullable    = false
  description = <<DESCRIPTION
(Optional) A map of system assigned managed identities to reference in role assignments.
The key is something unique to you. The value is the display name of the identity.

Example Input:

```hcl
user_assigned_managed_identities_by_display_name = {
  my-identity-1 = "My Identity 1"
  my-identity-2 = "My Identity 2"
}
```
DESCRIPTION
}

variable "user_assigned_managed_identities_by_client_id" {
  type        = map(string)
  default     = {}
  nullable    = false
  description = <<DESCRIPTION
(Optional) A map of system assigned managed identities to reference in role assignments.
The key is something unique to you. The value is the client id of the identity.

Example Input:

```hcl
user_assigned_managed_identities_by_client_id = {
  my-identity-1 = "00000000-0000-0000-0000-000000000001"
  my-identity-2 = "00000000-0000-0000-0000-000000000002"
}
```
DESCRIPTION
}

variable "user_assigned_managed_identities_by_principal_id" {
  type        = map(string)
  default     = {}
  nullable    = false
  description = <<DESCRIPTION
(Optional) A map of system assigned managed identities to reference in role assignments.
The key is something unique to you. The value is the principal id of the underying service principalk of the identity.

Example Input:

```hcl
user_assigned_managed_identities_by_principal_id = {
  my-identity-1 = "00000000-0000-0000-0000-000000000001"
  my-identity-2 = "00000000-0000-0000-0000-000000000002"
}
```
DESCRIPTION
}
