variable "users_by_user_principal_name" {
  type        = map(string)
  default     = {}
  nullable    = false
  description = <<DESCRIPTION
(Optional) A map of Entra ID users to reference in role assignments.
The key is something unique to you. The value is the user principal name (UPN) of the user.

Example Input:

```hcl
users_by_user_principal_name = {
  my-user-1 = "user1@example.com"
  my-user-2 = "user2@example.com"
}
```
DESCRIPTION
}

variable "users_by_mail" {
  type        = map(string)
  default     = {}
  nullable    = false
  description = <<DESCRIPTION
(Optional) A map of Entra ID users to reference in role assignments.
The key is something unique to you. The value is the mail address of the user.

Example Input:

```hcl
users_by_mail = {
  my-user-1 = "user.1@example.com"
  my-user-2 = "user.2@example.com"
}
```
DESCRIPTION
}

variable "users_by_mail_nickname" {
  type        = map(string)
  default     = {}
  nullable    = false
  description = <<DESCRIPTION
(Optional) A map of Entra ID users to reference in role assignments.
The key is something unique to you. The value is the mail nickname of the user.

Example Input:

```hcl
users_by_mail_nickname = {
  my-user-1 = "user1-nickname"
  my-user-2 = "user2-nickname"
}
```
DESCRIPTION
}

variable "users_by_employee_id" {
  type        = map(string)
  default     = {}
  nullable    = false
  description = <<DESCRIPTION
(Optional) A map of Entra ID users to reference in role assignments.
The key is something unique to you. The value is the employee ID of the user.

Example Input:

```hcl
users_by_employee_id = {
  my-user-1 = "1234567890"
  my-user-2 = "0987654321"
}
```
DESCRIPTION
}

variable "users_by_object_id" {
  type        = map(string)
  default     = {}
  nullable    = false
  description = <<DESCRIPTION
(Optional) A map of Entra ID users to reference in role assignments.
The key is something unique to you. The value is the object ID of the user.

Example Input:

```hcl
users_by_object_id = {
  my-user-1 = "00000000-0000-0000-0000-000000000001"
  my-user-2 = "00000000-0000-0000-0000-000000000002"
}
```
DESCRIPTION
}
