locals {
  groups = {
    group1 = "group1"
    group2 = "group2"
    group3 = "group3"
    group4 = "group4"
  }
}

resource "random_pet" "group_name" {
  for_each = local.groups
  length    = 2
  separator = "-"
}

resource "azuread_group" "test" {
  for_each = local.groups
  display_name        = "${each.key}-${local.module_name}-${random_pet.group_name[each.key].id}"
  mail_nickname       = "${each.key}-${random_pet.group_name[each.key].id}"
  security_enabled    = true
}
