locals {
  system_assigned_managed_identities_by_client_id = {
    (local.system_assigned_managed_identities.sami1) = data.azuread_service_principal.test[local.system_assigned_managed_identities.sami1].client_id
    (local.system_assigned_managed_identities.sami4) = data.azuread_service_principal.test[local.system_assigned_managed_identities.sami4].client_id
    (local.system_assigned_managed_identities.sami5) = data.azuread_service_principal.test[local.system_assigned_managed_identities.sami5].client_id
    (local.system_assigned_managed_identities.sami6) = data.azuread_service_principal.test[local.system_assigned_managed_identities.sami6].client_id
  }
  system_assigned_managed_identities_by_display_name = {
    (local.system_assigned_managed_identities.sami1) = azurerm_static_site.test[local.system_assigned_managed_identities.sami1].name
    (local.system_assigned_managed_identities.sami2) = azurerm_static_site.test[local.system_assigned_managed_identities.sami2].name
  }
  system_assigned_managed_identities_by_principal_id = {
    (local.system_assigned_managed_identities.sami1) = azurerm_static_site.test[local.system_assigned_managed_identities.sami1].identity[0].principal_id
    (local.system_assigned_managed_identities.sami3) = azurerm_static_site.test[local.system_assigned_managed_identities.sami3].identity[0].principal_id
  }
}
