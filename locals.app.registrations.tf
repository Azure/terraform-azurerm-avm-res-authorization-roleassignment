locals {
  app_registrations = merge(
    local.service_principal_by_client_id,
    local.service_principal_by_object_id
  )
  app_registrations_by_client_id_client_id = { for key, value in data.azuread_application.applications_by_client_id :
    key => value.client_id
  }
  app_registrations_by_display_name_client_id = { for key, value in data.azuread_application.applications_by_display_name :
    key => value.client_id
  }
  app_registrations_by_object_id_client_id = { for key, value in data.azuread_application.applications_by_object_id :
    key => value.client_id
  }
  app_registrations_client_ids = merge(
    local.app_registrations_by_display_name_client_id,
    local.app_registrations_by_client_id_client_id,
    local.app_registrations_by_object_id_client_id
  )
  service_principal_by_client_id = { for key, value in data.azuread_service_principal.service_principal_by_client_id :
    key => value.object_id
  }
  service_principal_by_object_id = { for key, value in data.azuread_service_principal.service_principal_by_object_id :
    key => value.object_id
  }
}

data "azuread_application" "applications_by_display_name" {
  for_each = var.app_registrations_by_display_name

  display_name = each.value
}

data "azuread_application" "applications_by_client_id" {
  for_each = var.app_registrations_by_client_id

  client_id = each.value
}

data "azuread_application" "applications_by_object_id" {
  for_each = var.app_registrations_by_object_id

  object_id = each.value
}

data "azuread_service_principal" "service_principal_by_object_id" {
  for_each = var.app_registrations_by_principal_id

  object_id = each.value
}

data "azuread_service_principal" "service_principal_by_client_id" {
  for_each = local.app_registrations_client_ids

  client_id = each.value
}
