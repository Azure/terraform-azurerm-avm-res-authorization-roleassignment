locals {
  # The test identity's service principal stands in for an app registration, so the example needs no Microsoft Graph write permissions.
  app_registrations_by_client_id = {
    (local.app_registrations.app_registration1) = data.azuread_client_config.current.client_id
  }
  app_registrations_by_principal_id = {
    (local.app_registrations.app_registration2) = data.azapi_client_config.current.object_id
  }
}

data "azuread_client_config" "current" {}
