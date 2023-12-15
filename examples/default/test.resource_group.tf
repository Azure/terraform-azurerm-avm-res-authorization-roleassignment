resource "random_pet" "resource_group_name" {
  length    = 2
  separator = "-"
}

resource "azurerm_resource_group" "test" {
  name     = "${local.module_name}-${random_pet.resource_group_name.id}"
  location = "westeurope"
}
