locals {
  users_by_user_principal_name = {
    (local.users.user1) = azuread_user.test[local.users.user1].user_principal_name
    (local.users.user2) = azuread_user.test[local.users.user2].user_principal_name
  }
  users_by_mail = {
    (local.users.user1) = azuread_user.test[local.users.user1].mail
    (local.users.user3) = azuread_user.test[local.users.user3].mail
  }
  users_by_mail_nickname = {
    (local.users.user1) = azuread_user.test[local.users.user1].mail_nickname
    (local.users.user4) = azuread_user.test[local.users.user4].mail_nickname
  }
  users_by_employee_id = {
    (local.users.user1) = azuread_user.test[local.users.user1].employee_id
    (local.users.user5) = azuread_user.test[local.users.user5].employee_id
  }
  users_by_object_id = {
    (local.users.user1) = azuread_user.test[local.users.user1].object_id
    (local.users.user6) = azuread_user.test[local.users.user6].object_id
    (local.users.user7) = azuread_user.test[local.users.user7].object_id
    (local.users.user8) = azuread_user.test[local.users.user8].object_id
  }
}
