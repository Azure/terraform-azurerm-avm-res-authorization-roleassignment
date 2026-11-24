module "role_assignments" {
  source = "../../"

  location                          = var.location
  app_registrations_by_client_id    = local.app_registrations_by_client_id
  app_registrations_by_principal_id = local.app_registrations_by_principal_id
  # source = "Azure/avm-ptn-authorization-roleassignment/azurerm"
  enable_telemetry                                            = var.enable_telemetry
  role_assignments_for_management_groups                      = local.role_assignments_for_management_groups
  role_assignments_for_resource_groups                        = local.role_assignments_for_resource_groups
  role_assignments_for_resources                              = local.role_assignments_for_resources
  role_assignments_for_scopes                                 = local.role_assignments_for_scopes
  role_assignments_for_subscriptions                          = local.role_assignments_for_subscriptions
  role_definitions                                            = local.role_definitions
  system_assigned_managed_identities_by_client_id             = local.system_assigned_managed_identities_by_client_id
  system_assigned_managed_identities_by_display_name          = local.system_assigned_managed_identities_by_display_name
  system_assigned_managed_identities_by_principal_id          = local.system_assigned_managed_identities_by_principal_id
  user_assigned_managed_identities_by_client_id               = local.user_assigned_managed_identities_by_client_id
  user_assigned_managed_identities_by_display_name            = local.user_assigned_managed_identities_by_display_name
  user_assigned_managed_identities_by_principal_id            = local.user_assigned_managed_identities_by_principal_id
  user_assigned_managed_identities_by_resource_group_and_name = local.user_assigned_managed_identities_by_resource_group_and_name

  depends_on = [
    azapi_resource.automation_account,
    azapi_resource.user_assigned_identity,
    data.azuread_service_principal.test,
    azapi_resource.management_group,
    time_sleep.after_management_group_creation
  ]
}

data "azapi_client_config" "current" {}
