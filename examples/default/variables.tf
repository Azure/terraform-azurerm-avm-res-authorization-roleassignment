variable "alternative_subscription_id" {
  type        = string
  default     = null
  description = <<DESCRIPTION
This variable is used to test the module with an alternative subscription id.
DESCRIPTION
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

variable "include_custom_role_definition" {
  type        = bool
  default     = false
  description = <<DESCRIPTION
This variable is used to control whether the example tests a custom role definition.
DESCRIPTION
}

variable "location" {
  type        = string
  default     = "eastus"
  description = "The Azure region for this module's resources or telemetry deployment."
  nullable    = false
}

variable "test_management_group_display_name" {
  type        = string
  default     = null
  description = <<DESCRIPTION
The display name of an existing management group to use as the test parent. If null, the tenant root management group is found by its immutable name, the tenant ID.
DESCRIPTION
}
