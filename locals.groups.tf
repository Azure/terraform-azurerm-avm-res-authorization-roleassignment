locals {
}

data "azuread_group" "groups_by_display_name" {
  for_each     = var.groups
  display_name = each.value
}

data "azuread_group" "groups_by_mail_nickname" {
  for_each      = var.groups
  mail_nickname = each.value
}

data "azuread_group" "groups_by_object_id" {
  for_each  = var.groups
  object_id = each.value
}
