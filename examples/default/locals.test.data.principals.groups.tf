locals {
  groups_by_display_name = {
    (local.groups.group1) = azuread_group.test[local.groups.group1].display_name
    (local.groups.group2) = azuread_group.test[local.groups.group2].display_name
  }
  groups_by_mail_nickname = {
    (local.groups.group1) = azuread_group.test[local.groups.group1].mail_nickname
    (local.groups.group3) = azuread_group.test[local.groups.group3].mail_nickname
  }
  groups_by_object_id = {
    (local.groups.group1) = azuread_group.test[local.groups.group1].object_id
    (local.groups.group4) = azuread_group.test[local.groups.group4].object_id
    (local.groups.group5) = azuread_group.test[local.groups.group5].object_id
  }
}
