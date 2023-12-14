locals {
  user_assigned_managed_identities = {
    uami1 = "uami1"
    uami2 = "uami2"
    uami3 = "uami3"
    uami4 = "uami4"
    uami5 = "uami5"
  }
}

resource "random_pet" "user_assigned_managed_identity" {
  for_each = local.user_assigned_managed_identities
  length    = 2
  separator = "-"
}

resource "azurerm_user_assigned_identity" "test" {
  for_each            = local.user_assigned_managed_identities
  name                = "${local.module_name}-${each.key}-${random_pet.user_assigned_managed_identity[each.key].id}"
  resource_group_name = azurerm_resource_group.test.name
  location            = azurerm_resource_group.test.location
}