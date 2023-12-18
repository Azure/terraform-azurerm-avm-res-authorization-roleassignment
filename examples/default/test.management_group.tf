resource "random_pet" "management_group_name" {
  length    = 2
  separator = "-"
}

data "azurerm_management_group" "test" {
  display_name = var.test_management_group_display_name
}

resource "azurerm_management_group" "test" {
  display_name               = "${local.module_name}-${random_pet.management_group_name.id}"
  name                       = "${local.module_name}-${random_pet.management_group_name.id}"
  parent_management_group_id = data.azurerm_management_group.test.id
}