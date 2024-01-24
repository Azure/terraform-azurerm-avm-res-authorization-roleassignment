variable "role_definitions" {
  type        = map(string)
  default     = {}
  nullable    = false
  description = <<DESCRIPTION
(Optional) A map of Azure Resource Manager role definitions to reference in role assignments.
The key is something unique to you. The value is a built in or custom role definition name.

Example Input:

```hcl
role_definitions = {
  owner       = "Owner"
  contributor = "Contributor"
  reader      = "Reader"
}
```
DESCRIPTION
}

variable "entra_id_role_definitions" {
  type        = map(string)
  default     = {}
  nullable    = false
  description = <<DESCRIPTION
(Optional) A map of Entra ID role definitions to reference in role assignments.
The key is something unique to you. The value is a built in or custom role definition name.

Example Input:

```hcl
entra_id_role_definitions = {
  directory-writer     = "Directory Writer"
  global-administrator = "Global Administrator"
}
```
DESCRIPTION
}
