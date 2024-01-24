locals {
  users = merge(
    local.users_by_user_principal_name,
    local.users_by_mail,
    local.users_by_mail_nickname,
    local.users_by_employee_id,
    local.users_by_object_id
  )
  users_by_employee_id = { for key, value in data.azuread_user.users_by_employee_id :
    key => value.id
  }
  users_by_mail = { for key, value in data.azuread_user.users_by_mail :
    key => value.id
  }
  users_by_mail_nickname = { for key, value in data.azuread_user.users_by_mail_nickname :
    key => value.id
  }
  users_by_object_id = { for key, value in data.azuread_user.users_by_object_id :
    key => value.id
  }
  users_by_user_principal_name = { for key, value in data.azuread_user.users_by_user_principal_name :
    key => value.id
  }
}

data "azuread_user" "users_by_user_principal_name" {
  for_each = var.users_by_user_principal_name

  user_principal_name = each.value
}

data "azuread_user" "users_by_mail" {
  for_each = var.users_by_mail

  mail = each.value
}

data "azuread_user" "users_by_mail_nickname" {
  for_each = var.users_by_mail_nickname

  mail_nickname = each.value
}

data "azuread_user" "users_by_employee_id" {
  for_each = var.users_by_employee_id

  employee_id = each.value
}

data "azuread_user" "users_by_object_id" {
  for_each = var.users_by_object_id

  object_id = each.value
}
