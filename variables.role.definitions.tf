variable "role_definitions" {
  type = map(object({
    id    = optional(string)
    name  = optional(string)
    scope = optional(string)
  }))
  default     = {}
  nullable    = false
  description = <<DESCRIPTION
(Optional) A map of Azure Resource Manager role definitions to reference in role assignments.
The key is something unique to you. The value is a built in or custom role definition name.

Example Input:

```hcl
role_definitions = {
  owner = {
    name = "Owner"
  }
  contributor = {
    name = "Contributor"
  }
  reader = {
    name = "Reader"
  }
  custom_role_by_name = {
    name  = "Custom Role"
    scope = "/subscriptions/00000000-0000-0000-0000-000000000000"
  }
  custom_role_by_id = {
    id = "00000000-0000-0000-0000-000000000000"
  }
}
```
DESCRIPTION
}

variable "entra_id_role_definitions" {
  type = map(object({
    template_id  = optional(string)
    display_name = optional(string)
  }))
  default     = {}
  nullable    = false
  description = <<DESCRIPTION
(Optional) A map of Entra ID role definitions to reference in role assignments.
The key is something unique to you. The value is a built in or custom role definition name.

- `template_id` - (Optional) The template ID of the role definition.
- `display_name` - (Optional) The display name of the role definition.

Example Input:

```hcl
entra_id_role_definitions = {
  directory-writer = {
    display_name = "Directory Writer"
  }
  global-administrator = {
    display_name = "Global Administrator"
  }
  custom_role_by_name = {
    display_name = "Custom Role"
  }
  custom_role_by_id = {
    template_id = "00000000-0000-0000-0000-000000000000"
  }
}
```
DESCRIPTION
}
