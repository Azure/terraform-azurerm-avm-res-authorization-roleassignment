resource "random_pet" "resource_group_name" {
  length    = 2
  separator = "-"
}

resource "azurerm_resource_group" "test" {
  name     = "${local.module_name}-${random_pet.resource_group_name.id}"
  location = "westeurope"
}

resource "azurerm_resource_group" "alternative" {
  provider = azurerm.alternative
  count    = local.include_alternative_subscription ? 1 : 0
  name     = "${local.module_name}-${random_pet.resource_group_name.id}-alt"
  location = "westeurope"
}
