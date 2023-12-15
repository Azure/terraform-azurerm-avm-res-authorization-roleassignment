resource "random_pet" "username" {
  for_each  = local.users
  length    = 2
  separator = "-"
}

resource "random_password" "password" {
  for_each         = local.users
  length           = 20
  special          = true
  min_numeric      = 1
  min_lower        = 1
  min_upper        = 1
  min_special      = 1
  override_special = "_%@"

}

resource "random_string" "employee_id" {
  for_each = local.users
  length   = 10
  special  = false
  upper    = false
  lower    = false
  numeric  = true
}

resource "azuread_user" "test" {
  for_each            = local.users
  user_principal_name = "${each.key}-${random_pet.username[each.key].id}@${var.spn_domain}"
  display_name        = "${local.module_name}-${each.key}-${random_pet.username[each.key].id}"
  mail_nickname       = "${each.key}-${random_pet.username[each.key].id}"
  account_enabled     = false
  mail                = "${each.key}-${random_pet.username[each.key].id}@avm-test.com"
  password            = random_password.password[each.key].result
  employee_id         = random_string.employee_id[each.key].result
}
