locals {
  user_assigned_managed_identities_by_client_id = {
    (local.user_assigned_managed_identities.uami1) = azapi_resource.user_assigned_identity[local.user_assigned_managed_identities.uami1].output.properties.clientId
    (local.user_assigned_managed_identities.uami4) = azapi_resource.user_assigned_identity[local.user_assigned_managed_identities.uami4].output.properties.clientId
  }
  user_assigned_managed_identities_by_display_name = {
    (local.user_assigned_managed_identities.uami1) = azapi_resource.user_assigned_identity[local.user_assigned_managed_identities.uami2].name
    (local.user_assigned_managed_identities.uami3) = azapi_resource.user_assigned_identity[local.user_assigned_managed_identities.uami2].name
  }
  user_assigned_managed_identities_by_principal_id = {
    (local.user_assigned_managed_identities.uami1) = azapi_resource.user_assigned_identity[local.user_assigned_managed_identities.uami1].output.properties.principalId
    (local.user_assigned_managed_identities.uami5) = azapi_resource.user_assigned_identity[local.user_assigned_managed_identities.uami5].output.properties.principalId
    (local.user_assigned_managed_identities.uami6) = azapi_resource.user_assigned_identity[local.user_assigned_managed_identities.uami6].output.properties.principalId
    (local.user_assigned_managed_identities.uami7) = azapi_resource.user_assigned_identity[local.user_assigned_managed_identities.uami7].output.properties.principalId
  }
  user_assigned_managed_identities_by_resource_group_and_name = {
    (local.user_assigned_managed_identities.uami1) = {
      name                = azapi_resource.user_assigned_identity[local.user_assigned_managed_identities.uami1].name
      resource_group_name = azapi_resource.resource_group.name
    }
    (local.user_assigned_managed_identities.uami2) = {
      name                = azapi_resource.user_assigned_identity[local.user_assigned_managed_identities.uami2].name
      resource_group_name = azapi_resource.resource_group.name
    }
  }
}
