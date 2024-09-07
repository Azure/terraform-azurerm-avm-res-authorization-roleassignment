resource "random_pet" "static_site" {
  for_each = local.system_assigned_managed_identities

  length    = 2
  separator = "-"
}

resource "azurerm_static_web_app" "test" {
  for_each = local.system_assigned_managed_identities

  location            = azurerm_resource_group.test.location
  name                = "${local.module_name}-${each.key}-${random_pet.static_site[each.key].id}"
  resource_group_name = azurerm_resource_group.test.name
  sku_size            = "Standard"
  sku_tier            = "Standard"

  identity {
    type = "SystemAssigned"
  }
}

resource "time_sleep" "before_service_principal_read_creation" {
  create_duration  = "20s"
  destroy_duration = "10s"

  depends_on = [azurerm_static_web_app.test]
}

data "azuread_service_principal" "test" {
  for_each = local.system_assigned_managed_identities

  object_id = azurerm_static_web_app.test[each.key].identity[0].principal_id

  depends_on = [time_sleep.before_service_principal_read_creation]
}
