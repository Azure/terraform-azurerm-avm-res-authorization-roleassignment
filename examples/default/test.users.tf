resource "random_pet" "username" {
  count     = local.test_user_count
  length    = 2
  separator = "-"
}

resource "random_password" "password" {
  count            = local.test_user_count
  length           = 16
  special          = true
  override_special = "_%@"
}

resource "random_string" "employee_id" {
  count   = local.test_user_count
  length  = 10
  special = false
  upper   = false
  lower   = false
  numeric = true
}

resource "azuread_user" "test" {
  count               = local.test_user_count
  user_principal_name = "${random_pet.username[count.index].id}-${count.index}@${var.spn_domain}"
  display_name        = "${local.module_name}-${random_pet.username[count.index].id}-${count.index}"
  mail_nickname       = "${random_pet.username[count.index].id}-${count.index}"
  account_enabled     = false
  mail                = "${random_pet.username[count.index].id}-${count.index}@avm-test.com"
  password            = random_password.password[count.index].result
  employee_id         = random_string.employee_id[count.index].result
}
