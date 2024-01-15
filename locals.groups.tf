locals {
  groups = merge(
    local.groups_by_display_name,
    local.groups_by_mail_nickname,
    local.groups_by_object_id
  )
  groups_by_display_name = { for key, value in data.azuread_group.groups_by_display_name :
    key => value.id
  }
  groups_by_mail_nickname = { for key, value in data.azuread_group.groups_by_mail_nickname :
    key => value.id
  }
  groups_by_object_id = { for key, value in data.azuread_group.groups_by_object_id :
    key => value.id
  }
}

data "azuread_group" "groups_by_display_name" {
  for_each = var.groups_by_display_name

  display_name = each.value
}

data "azuread_group" "groups_by_mail_nickname" {
  for_each = var.groups_by_mail_nickname

  mail_nickname = each.value
}

data "azuread_group" "groups_by_object_id" {
  for_each = var.groups_by_object_id

  object_id = each.value
}
