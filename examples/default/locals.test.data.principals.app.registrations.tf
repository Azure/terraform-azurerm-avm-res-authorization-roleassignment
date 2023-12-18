locals {
  app_registrations_by_display_name = {
    (local.app_registrations.app_registration1) = azuread_application.test[local.app_registrations.app_registration1].display_name
    (local.app_registrations.app_registration2) = azuread_application.test[local.app_registrations.app_registration2].display_name
  }
  app_registrations_by_client_id = {
    (local.app_registrations.app_registration1) = azuread_application.test[local.app_registrations.app_registration1].client_id
    (local.app_registrations.app_registration3) = azuread_application.test[local.app_registrations.app_registration3].client_id
  }
  app_registrations_by_object_id = {
    (local.app_registrations.app_registration1) = azuread_application.test[local.app_registrations.app_registration1].object_id
    (local.app_registrations.app_registration4) = azuread_application.test[local.app_registrations.app_registration4].object_id
  }
  app_registrations_by_principal_id = {
    (local.app_registrations.app_registration1) = azuread_service_principal.test[local.app_registrations.app_registration1].object_id
    (local.app_registrations.app_registration5) = azuread_service_principal.test[local.app_registrations.app_registration5].object_id
    (local.app_registrations.app_registration6) = azuread_service_principal.test[local.app_registrations.app_registration6].object_id
  }
}
