resource "random_pet" "username" {
  for_each = local.users

  length    = 2
  separator = "-"
}

resource "random_password" "password" {
  for_each = local.users

  length           = 20
  min_lower        = 1
  min_numeric      = 1
  min_special      = 1
  min_upper        = 1
  override_special = "_%@"
  special          = true
}

resource "random_string" "employee_id" {
  for_each = local.users

  length  = 10
  lower   = false
  numeric = true
  special = false
  upper   = false
}

resource "azuread_user" "test" {
  for_each = local.users

  display_name        = "${local.module_name}-${each.key}-${random_pet.username[each.key].id}"
  user_principal_name = "${each.key}-${random_pet.username[each.key].id}@${var.spn_domain}"
  account_enabled     = false
  employee_id         = random_string.employee_id[each.key].result
  mail                = "${each.key}-${random_pet.username[each.key].id}@avm-test.com"
  mail_nickname       = "${each.key}-${random_pet.username[each.key].id}"
  password            = random_password.password[each.key].result
}
