resource "random_pet" "user_assigned_managed_identity" {
  for_each = local.user_assigned_managed_identities

  length    = 2
  separator = "-"
}

resource "azapi_resource" "user_assigned_identity" {
  for_each = local.user_assigned_managed_identities

  location  = "westeurope"
  name      = "${local.module_name}-${each.key}-${random_pet.user_assigned_managed_identity[each.key].id}"
  parent_id = azapi_resource.resource_group.id
  type      = "Microsoft.ManagedIdentity/userAssignedIdentities@2024-11-30"
  response_export_values = [
    "properties.clientId",
    "properties.principalId",
  ]
}
