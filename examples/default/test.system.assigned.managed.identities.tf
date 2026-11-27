resource "random_pet" "automation_account" {
  for_each = local.system_assigned_managed_identities

  length    = 2
  separator = "-"
}

resource "azapi_resource" "automation_account" {
  for_each = local.system_assigned_managed_identities

  location  = var.location
  name      = "${local.module_name}-${each.key}-${random_pet.automation_account[each.key].id}"
  parent_id = azapi_resource.resource_group.id
  type      = "Microsoft.Automation/automationAccounts@2023-11-01"
  body = {
    identity = {
      type = "SystemAssigned"
    }
    properties = {
      sku = {
        name = "Basic"
      }
    }
  }
  response_export_values = [
    "identity.principalId",
  ]
}

resource "time_sleep" "before_service_principal_read_creation" {
  create_duration  = "20s"
  destroy_duration = "10s"

  depends_on = [azapi_resource.automation_account]
}

data "azuread_service_principal" "test" {
  for_each = local.system_assigned_managed_identities

  object_id = azapi_resource.automation_account[each.key].output.identity.principalId

  depends_on = [time_sleep.before_service_principal_read_creation]
}
