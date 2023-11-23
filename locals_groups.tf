locals {
  groups = { for key, value in var.groups : key => coalesce(
    data.azuread_group.groups_by_display_name[key].id,
    data.azuread_group.groups_by_mail_nickname[key].id,
    data.azuread_group.groups_by_object_id[key].id
  ) }
}

data "azuread_group" "groups_by_display_name" {
  for_each     = var.groups
  display_name = each.value
}

data "azuread_group" "groups_by_mail_nickname" {
  for_each      = var.users
  mail_nickname = each.value
}

data "azuread_group" "groups_by_object_id" {
  for_each  = var.users
  object_id = each.value
}
