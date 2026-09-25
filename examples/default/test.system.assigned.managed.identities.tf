resource "random_pet" "static_site" {
  for_each = local.system_assigned_managed_identities

  length    = 2
  separator = "-"
}

resource "azapi_resource" "static_web_app" {
  for_each = local.system_assigned_managed_identities

  location  = "westeurope"
  name      = "${local.module_name}-${each.key}-${random_pet.static_site[each.key].id}"
  parent_id = azapi_resource.resource_group.id
  type      = "Microsoft.Web/staticSites@2025-03-01"
  body = {
    identity = {
      type = "SystemAssigned"
    }
    sku = {
      name = "Standard"
      tier = "Standard"
    }
  }
  response_export_values = [
    "identity.principalId",
  ]
}

resource "time_sleep" "before_service_principal_read_creation" {
  create_duration  = "20s"
  destroy_duration = "10s"

  depends_on = [azapi_resource.static_web_app]
}

data "azuread_service_principal" "test" {
  for_each = local.system_assigned_managed_identities

  object_id = azapi_resource.static_web_app[each.key].output.identity.principalId

  depends_on = [time_sleep.before_service_principal_read_creation]
}
