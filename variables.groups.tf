variable "groups_by_display_name" {
  type        = map(string)
  default     = {}
  description = <<DESCRIPTION
(Optional) A map of Entra ID groups to reference in role assignments.
The key is something unique to you. The value is the display name of the group.

Example Input:

```hcl
groups_by_display_name = {
  my-group-1 = "My Group 1"
  my-group-2 = "My Group 2"
}
```
DESCRIPTION
}

variable "groups_by_mail_nickname" {
  type        = map(string)
  default     = {}
  description = <<DESCRIPTION
(Optional) A map of Entra ID groups to reference in role assignments.
The key is something unique to you. The value is the mail nickname of the group.

Example Input:

```hcl
groups_by_mail_nickname = {
  my-group-1 = "my-group-1-nickname"
  my-group-2 = "my-group-2-nickname"
}
```
DESCRIPTION
}

variable "groups_by_object_id" {
  type        = map(string)
  default     = {}
  description = <<DESCRIPTION
(Optional) A map of Entra ID groups to reference in role assignments.
The key is something unique to you. The value is the object ID of the group.

Example Input:

```hcl
groups_by_object_id = {
  my-group-1 = "00000000-0000-0000-0000-000000000001"
  my-group-2 = "00000000-0000-0000-0000-000000000002"
}
```
DESCRIPTION
}
