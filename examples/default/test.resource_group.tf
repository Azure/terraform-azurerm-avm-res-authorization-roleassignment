resource "random_pet" "resource_group_name" {
  length    = 2
  separator = "-"
}

resource "azapi_resource" "resource_group" {
  location               = "westeurope"
  name                   = "${local.module_name}-${random_pet.resource_group_name.id}"
  parent_id              = "/subscriptions/${data.azapi_client_config.current.subscription_id}"
  type                   = "Microsoft.Resources/resourceGroups@2025-04-01"
  response_export_values = []
}

resource "azapi_resource" "alternative_resource_group" {
  count = local.include_alternative_subscription ? 1 : 0

  location               = "westeurope"
  name                   = "${local.module_name}-${random_pet.resource_group_name.id}-alt"
  parent_id              = "/subscriptions/${var.alternative_subscription_id}"
  type                   = "Microsoft.Resources/resourceGroups@2025-04-01"
  response_export_values = []
}
