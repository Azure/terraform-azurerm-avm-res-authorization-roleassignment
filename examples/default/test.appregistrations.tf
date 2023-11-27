resource "random_pet" "app_registration_display_name" {
  count = local.test_app_registrstion_count
  length    = 2
  separator = "-"
}

resource "azuread_application" "test" {
  count = local.test_app_registrstion_count
  display_name = "${random_pet.app_registration_display_name[count.index].id}-${count.index}"
  description = "${local.module_name}-${random_pet.app_registration_display_name[count.index].id}-${count.index}"
}

resource "azuread_service_principal" "test" {
  count = local.test_app_registrstion_count
  client_id                    = azuread_application.test[count.index].client_id
}