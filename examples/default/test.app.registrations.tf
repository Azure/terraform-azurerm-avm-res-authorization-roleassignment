locals {
  app_registrations = {
    app_registration1 = "app_registration1"
    app_registration2 = "app_registration2"
    app_registration3 = "app_registration3"
    app_registration4 = "app_registration4"
    app_registration5 = "app_registration5"
  }
}

resource "random_pet" "app_registration_display_name" {
  for_each = local.app_registrations
  length    = 2
  separator = "-"
}

resource "azuread_application" "test" {
  for_each = local.app_registrations
  display_name = "${each.key}-${random_pet.app_registration_display_name[each.key].id}"
  description  = "${local.module_name}-${each.key}-${random_pet.app_registration_display_name[each.key].id}"
}

resource "azuread_service_principal" "test" {
  for_each = local.app_registrations
  client_id = azuread_application.test[each.key].client_id
}
