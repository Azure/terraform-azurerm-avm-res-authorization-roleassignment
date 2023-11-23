locals {
  users = { for key, value in var.users : key => coalesce(
    data.azuread_user.users_by_user_principal_name[key].id,
    data.azuread_user.users_by_mail[key].id,
    data.azuread_user.users_by_mail_nickname[key].id,
    data.azuread_user.users_by_employee_id[key].id,
    data.azuread_user.users_by_object_id[key].id
  ) }
}

data "azuread_user" "users_by_user_principal_name" {
  for_each            = var.users
  user_principal_name = each.value
}

data "azuread_user" "users_by_mail" {
  for_each = var.users
  mail     = each.value
}

data "azuread_user" "users_by_mail_nickname" {
  for_each = var.users
  mail     = each.value
}

data "azuread_user" "users_by_employee_id" {
  for_each = var.users
  mail     = each.value
}

data "azuread_user" "users_by_object_id" {
  for_each  = var.users
  object_id = each.value
}