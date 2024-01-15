variable "app_registrations_by_display_name" {
  type        = map(string)
  default     = {}
  description = <<DESCRIPTION
(Optional) A map of Entra ID application registrations to reference in role assignments.
The key is something unique to you. The value is the display name of the application registration.

Example Input:

```hcl
app_registrations_by_display_name = {
  my-app-1 = "My App 1"
  my-app-2 = "My App 2"
}
```
DESCRIPTION
}

variable "app_registrations_by_client_id" {
  type        = map(string)
  default     = {}
  description = <<DESCRIPTION
(Optional) A map of Entra ID application registrations to reference in role assignments.
The key is something unique to you. The value is the client ID (application ID) of the application registration.

Example Input:

```hcl
app_registrations_by_client_id = {
  my-app-1 = "00000000-0000-0000-0000-000000000001"
  my-app-2 = "00000000-0000-0000-0000-000000000002"
}
```
DESCRIPTION
}

variable "app_registrations_by_object_id" {
  type        = map(string)
  default     = {}
  description = <<DESCRIPTION
(Optional) A map of Entra ID application registrations to reference in role assignments.
The key is something unique to you. The value is the object ID of the application registration.

Example Input:

```hcl
app_registrations_by_object_id = {
  my-app-1 = "00000000-0000-0000-0000-000000000001"
  my-app-2 = "00000000-0000-0000-0000-000000000002"
}
```
DESCRIPTION
}

variable "app_registrations_by_principal_id" {
  type        = map(string)
  default     = {}
  description = <<DESCRIPTION
(Optional) A map of Entra ID application registrations to reference in role assignments.
The key is something unique to you. The value is the principal ID of the service principal backing the application registration.

Example Input:

```hcl
app_registrations_by_principal_id = {
  my-app-1 = "00000000-0000-0000-0000-000000000001"
  my-app-2 = "00000000-0000-0000-0000-000000000002"
}
```
DESCRIPTION
}
