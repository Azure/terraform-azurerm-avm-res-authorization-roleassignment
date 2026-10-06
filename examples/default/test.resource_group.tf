resource "random_pet" "resource_group_name" {
  length    = 2
  separator = "-"
}

resource "azurerm_resource_group" "test" {
  location = "westeurope"
  name     = "${local.module_name}-${random_pet.resource_group_name.id}"
}

resource "azurerm_resource_group" "alternative" {
  count    = local.include_alternative_subscription ? 1 : 0
  provider = azurerm.alternative

  location = "westeurope"
  name     = "${local.module_name}-${random_pet.resource_group_name.id}-alt"
}
