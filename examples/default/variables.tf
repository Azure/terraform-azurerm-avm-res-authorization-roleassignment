variable "enable_telemetry" {
  type        = bool
  default     = true
  description = <<DESCRIPTION
This variable controls whether or not telemetry is enabled for the module.
For more information see https://aka.ms/avm/telemetryinfo.
If it is set to false, then no telemetry will be collected.
DESCRIPTION
}

variable "spn_domain" {
  type = string

  default     = "changeme.com"
  description = <<DESCRIPTION
The domain name that is post-fixed on the service principal name.
This must be a valid domain registered in your Entra ID tenant.
DESCRIPTION
}

variable "include_custom_role_definition" {
  type        = bool
  default     = true
  description = <<DESCRIPTION
This variable is used to control whether the example tests a custom role definition.
DESCRIPTION
}

variable "alternative_subscription_id" {
  type        = string
  default     = null
  description = <<DESCRIPTION
This variable is used to test the module with an alternative subscription id.
DESCRIPTION
}