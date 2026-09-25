variable "ignore_body_changes" {
  type = object({
    authorization_role_assignments = optional(list(string), [])
  })
  default     = {}
  description = <<DESCRIPTION
Body-relative paths to ignore for each AzAPI resource. Paths use dot notation, ignored configuration is not sent to Azure, and changes take effect only after apply.

- `authorization_role_assignments` - Paths ignored on role assignment resources.
DESCRIPTION
  nullable    = false
}

variable "resource_types" {
  type = object({
    authorization_role_assignments = optional(string, "Microsoft.Authorization/roleAssignments@2022-04-01")
  })
  default     = {}
  description = <<DESCRIPTION
AzAPI resource types and API versions used by the module.

- `authorization_role_assignments` - Resource type and API version for role assignments.
DESCRIPTION
  nullable    = false
}

variable "retry" {
  type = object({
    error_message_regex  = optional(list(string))
    interval_seconds     = optional(number)
    max_interval_seconds = optional(number)
  })
  default     = null
  description = <<DESCRIPTION
Retry configuration applied to every supported AzAPI resource declared by the module. Defaults to `null` (no custom retry).

- `error_message_regex` - Regex patterns matching error messages that trigger a retry.
- `interval_seconds` - Initial interval between retries in seconds.
- `max_interval_seconds` - Maximum interval between retries in seconds.
DESCRIPTION
}

variable "timeouts" {
  type = object({
    create = optional(string)
    read   = optional(string)
    update = optional(string)
    delete = optional(string)
  })
  default     = null
  description = <<DESCRIPTION
Default per-operation timeouts applied to every supported AzAPI resource declared by the module. Defaults to `null` (provider defaults). Each value is a Go duration string, such as `30m` or `1h`.

- `create` - Timeout for create operations.
- `read` - Timeout for read operations.
- `update` - Timeout for update operations.
- `delete` - Timeout for delete operations.
DESCRIPTION
}
