variable "spn_domain" {
  type        = string
  default     = "changeme.com"
  description = <<DESCRIPTION
The domain name that is post-fixed on the service principal name.
This must be a valid domain registered in your Entra ID tenant.
DESCRIPTION
}
