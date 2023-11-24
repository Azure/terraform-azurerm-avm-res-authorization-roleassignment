output "users" {
  value = local.users
}

output "test"  {
  value = {
    users_find_by_user_principal_name = local.users_find_by_user_principal_name
    users_find_by_mail = local.users_find_by_mail
    users_find_by_mail_nickname = local.users_find_by_mail_nickname
    users_find_by_employee_id = local.users_find_by_employee_id
    users_find_by_object_id = local.users_find_by_object_id
  }
}