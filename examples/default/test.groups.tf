resource "random_pet" "group_name" {
  count     = local.test_group_count
  length    = 2
  separator = "-"
}

resource "azuread_group" "test" {
  count               = local.test_group_count
  display_name        = "${local.module_name}-${random_pet.group_name[count.index].id}-${count.index}"
  mail_nickname       = "${random_pet.group_name[count.index].id}-${count.index}"
  security_enabled    = true
}
