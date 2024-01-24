variable "system_assigned_managed_identities_by_display_name" {
  type        = map(string)
  default     = {}
  nullable    = false
  description = <<DESCRIPTION
(Optional) A map of system assigned managed identities to reference in role assignments.
The key is something unique to you. The value is the display name of the identity / compute instance.

Example Input:

```hcl
system_assigned_managed_identities_by_display_name = {
  my-vm-1 = "My VM 1"
  my-vm-2 = "My VM 2"
}
```
DESCRIPTION
}

variable "system_assigned_managed_identities_by_client_id" {
  type        = map(string)
  default     = {}
  nullable    = false
  description = <<DESCRIPTION
(Optional) A map of system assigned managed identities to reference in role assignments.
The key is something unique to you. The value is the client id of the identity.

Example Input:

```hcl
system_assigned_managed_identities_by_client_id = {
  my-vm-1 = "00000000-0000-0000-0000-000000000001"
  my-vm-2 = "00000000-0000-0000-0000-000000000002"
}
```
DESCRIPTION
}

variable "system_assigned_managed_identities_by_principal_id" {
  type        = map(string)
  default     = {}
  nullable    = false
  description = <<DESCRIPTION
(Optional) A map of system assigned managed identities to reference in role assignments.
The key is something unique to you. The value is the principal id of the underying service principalk of the identity.

Example Input:

```hcl
system_assigned_managed_identities_by_principal_id = {
  my-vm-1 = "00000000-0000-0000-0000-000000000001"
  my-vm-2 = "00000000-0000-0000-0000-000000000002"
}
```
DESCRIPTION
}
