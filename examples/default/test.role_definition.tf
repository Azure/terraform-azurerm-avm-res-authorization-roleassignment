resource "random_uuid" "test_role_definition" {
  count = var.include_custom_role_definition ? 1 : 0
}

resource "azapi_resource" "test_role_definition" {
  count = var.include_custom_role_definition ? 1 : 0

  name      = random_uuid.test_role_definition[0].result
  parent_id = data.azurerm_management_group.test.id
  type      = "Microsoft.Authorization/roleDefinitions@2022-04-01"
  body = {
    properties = {
      roleName         = "Example-Role-${random_uuid.test_role_definition[0].result}"
      type             = "CustomRole"
      assignableScopes = [data.azurerm_management_group.test.id]
      permissions = [{
        actions = ["Microsoft.Resources/subscriptions/resourceGroups/read"]
      }]
    }
  }
  response_export_values = []
}
