module "role_assignments" {
  source = "../../"
  # source = "Azure/avm-ptn-authorization-roleassignment/azurerm"
  enable_telemetry = var.enable_telemetry

  users_by_user_principal_name = local.users_by_user_principal_name
  users_by_mail                = local.users_by_mail
  users_by_mail_nickname       = local.users_by_mail_nickname
  users_by_employee_id         = local.users_by_employee_id
  users_by_object_id           = local.users_by_object_id

  groups_by_display_name  = local.groups_by_display_name
  groups_by_mail_nickname = local.groups_by_mail_nickname
  groups_by_object_id     = local.groups_by_object_id

  app_registrations_by_display_name = local.app_registrations_by_display_name
  app_registrations_by_client_id    = local.app_registrations_by_client_id
  app_registrations_by_object_id    = local.app_registrations_by_object_id
  app_registrations_by_principal_id = local.app_registrations_by_principal_id

  system_assigned_managed_identities_by_display_name = local.system_assigned_managed_identities_by_display_name
  system_assigned_managed_identities_by_principal_id = local.system_assigned_managed_identities_by_principal_id
  system_assigned_managed_identities_by_client_id    = local.system_assigned_managed_identities_by_client_id

  user_assigned_managed_identities_by_resource_group_and_name = local.user_assigned_managed_identities_by_resource_group_and_name
  user_assigned_managed_identities_by_display_name            = local.user_assigned_managed_identities_by_display_name
  user_assigned_managed_identities_by_client_id               = local.user_assigned_managed_identities_by_client_id
  user_assigned_managed_identities_by_principal_id            = local.user_assigned_managed_identities_by_principal_id

  role_definitions          = local.role_definitions
  entra_id_role_definitions = local.entra_id_role_definitions

  role_assignments_for_resources         = local.role_assignments_for_resources
  role_assignments_for_resource_groups   = local.role_assignments_for_resource_groups
  role_assignments_for_subscriptions     = local.role_assignments_for_subscriptions
  role_assignments_for_management_groups = local.role_assignments_for_management_groups
  role_assignments_for_scopes            = local.role_assignments_for_scopes
  role_assignments_for_entra_id          = local.role_assignments_for_entra_id

  depends_on = [
    azuread_service_principal.test,
    azuread_user.test,
    azuread_group.test,
    azuread_application.test,
    azurerm_static_site.test,
    azurerm_user_assigned_identity.test,
    data.azuread_service_principal.test,
    azurerm_management_group.test
  ]
}
