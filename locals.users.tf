locals {
  # Prepare the search criteria for users
  users_find_by_user_principal_name = { for key, value in var.users :
    key => value.user_principal_name if value.user_principal_name != null && value.user_principal_name != ""
  }
  users_find_by_mail = { for key, value in var.users :
    key => value.mail if value.mail != null && value.mail != ""
  }
  users_find_by_mail_nickname = { for key, value in var.users :
    key => value.mail_nickname if value.mail_nickname != null && value.mail_nickname != ""
  }
  users_find_by_employee_id = { for key, value in var.users :
    key => value.employee_id if value.employee_id != null && value.employee_id != ""
  }
  users_find_by_object_id = { for key, value in var.users :
    key => value.object_id if value.object_id != null && value.object_id != ""
  }

  # Get the user id from the data sources
  users_by_user_principal_name = { for key, value in data.azuread_user.users_by_user_principal_name :
    key => value.id
  }
  users_by_mail = { for key, value in data.azuread_user.users_by_mail :
    key => value.id
  }
  users_by_mail_nickname = { for key, value in data.azuread_user.users_by_mail_nickname :
    key => value.id
  }
  users_by_employee_id = { for key, value in data.azuread_user.users_by_employee_id :
    key => value.id
  }
  users_by_object_id = { for key, value in data.azuread_user.users_by_object_id :
    key => value.id
  }

  # Merge the search results
  users = merge(
    local.users_by_user_principal_name,
    local.users_by_mail,
    local.users_by_mail_nickname,
    local.users_by_employee_id,
    local.users_by_object_id
  )
}

data "azuread_user" "users_by_user_principal_name" {
  for_each            = local.users_find_by_user_principal_name
  user_principal_name = each.value
}

data "azuread_user" "users_by_mail" {
  for_each = local.users_find_by_mail
  mail     = each.value
}

data "azuread_user" "users_by_mail_nickname" {
  for_each = local.users_find_by_mail_nickname
  mail_nickname =      each.value
}

data "azuread_user" "users_by_employee_id" {
  for_each = local.users_find_by_employee_id
  employee_id      = each.value
}

data "azuread_user" "users_by_object_id" {
  for_each  = local.users_find_by_object_id
  object_id = each.value
}