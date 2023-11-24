locals {

}

data "azuread_application" "applications_by_display_name" {
  for_each     = var.app_registrations
  display_name = each.value
}

data "azuread_application" "applications_by_client_id" {
  for_each  = var.app_registrations
  client_id = each.value
}

data "azuread_application" "applications_by_object_id" {
  for_each  = var.app_registrations
  object_id = each.value
}

#data "azuread_service_principal" "this" {
#  for_each  = local.app_registration_client_ids
#  client_id = each.value
#}
