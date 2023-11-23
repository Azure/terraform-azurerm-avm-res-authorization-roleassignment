locals {
  app_registration_client_ids = { for key, value in var.app_registrations : key => coalesce(
    data.azuread_application.applications_by_display_name[key].client_id,
    data.azuread_application.applications_by_client_id[key].client_id,
    data.azuread_application.applications_by_object_id[key].client_id
  ) }

  app_registrations = { for key, value in var.app_registrations : key => data.azuread_service_principal.this[key].id }
}

data "azuread_application" "applications_by_display_name" {
  for_each     = var.groups
  display_name = each.value
}

data "azuread_application" "applications_by_client_id" {
  for_each  = var.users
  client_id = each.value
}

data "azuread_application" "applications_by_object_id" {
  for_each  = var.users
  object_id = each.value
}

data "azuread_service_principal" "this" {
  for_each  = local.app_registration_client_ids
  client_id = each.value
}
