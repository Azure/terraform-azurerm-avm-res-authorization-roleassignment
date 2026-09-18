variable "spn_domain" {
  type        = string
  default     = "changeme.com"
  description = <<DESCRIPTION
The domain name that is post-fixed on the service principal name.
This must be a valid domain registered in your Entra ID tenant.
DESCRIPTION
}

variable "enable_telemetry" {
  type        = bool
  default     = false
  description = <<DESCRIPTION
This variable controls whether or not telemetry is enabled for the module.
For more information see <https://aka.ms/avm/telemetryinfo>.
If it is set to false, then no telemetry will be collected.
DESCRIPTION
}
