locals {
  user_assigned_managed_identities_by_client_id = {
    (local.user_assigned_managed_identities.uami1) = azurerm_user_assigned_identity.test[local.user_assigned_managed_identities.uami1].client_id
    (local.user_assigned_managed_identities.uami4) = azurerm_user_assigned_identity.test[local.user_assigned_managed_identities.uami4].client_id
  }
  user_assigned_managed_identities_by_display_name = {
    (local.user_assigned_managed_identities.uami1) = azurerm_user_assigned_identity.test[local.user_assigned_managed_identities.uami2].name
    (local.user_assigned_managed_identities.uami3) = azurerm_user_assigned_identity.test[local.user_assigned_managed_identities.uami2].name
  }
  user_assigned_managed_identities_by_principal_id = {
    (local.user_assigned_managed_identities.uami1) = azurerm_user_assigned_identity.test[local.user_assigned_managed_identities.uami1].principal_id
    (local.user_assigned_managed_identities.uami5) = azurerm_user_assigned_identity.test[local.user_assigned_managed_identities.uami5].principal_id
    (local.user_assigned_managed_identities.uami6) = azurerm_user_assigned_identity.test[local.user_assigned_managed_identities.uami6].principal_id
    (local.user_assigned_managed_identities.uami7) = azurerm_user_assigned_identity.test[local.user_assigned_managed_identities.uami7].principal_id
  }
  user_assigned_managed_identities_by_resource_group_and_name = {
    (local.user_assigned_managed_identities.uami1) = {
      name                = azurerm_user_assigned_identity.test[local.user_assigned_managed_identities.uami1].name
      resource_group_name = azurerm_user_assigned_identity.test[local.user_assigned_managed_identities.uami1].resource_group_name
    }
    (local.user_assigned_managed_identities.uami2) = {
      name                = azurerm_user_assigned_identity.test[local.user_assigned_managed_identities.uami2].name
      resource_group_name = azurerm_user_assigned_identity.test[local.user_assigned_managed_identities.uami2].resource_group_name
    }
  }
}
