locals {
  entra_id_role_assignments = merge(
    local.role_assignments_for_entra_id
  )
  role_assignments = merge(
    local.role_assignments_for_resources,
    local.role_assignments_for_resource_groups,
    local.role_assignments_for_subscriptions,
    local.role_assignments_for_management_groups,
    local.role_assignments_for_scopes
  )
  role_assignments_all = merge(
    local.role_assignments,
    local.role_assignments_azure_resource_manager_normalized
  )
  role_assignments_normalized = {
    for key, value in local.role_assignments :
    key => merge(
      {
        condition                              = null
        condition_version                      = null
        delegated_managed_identity_resource_id = null
        description                            = null
        principal_type                         = null
        skip_service_principal_aad_check       = false
      },
      value,
      {
        # Azure returns the role definition ID in a form that depends on the assignment scope. Sending that form keeps the body stable between plans.
        role_definition_id = value.role_definition_id == null ? null : (
          startswith(lower(value.scope), "/subscriptions/")
          ? "/subscriptions/${split("/", value.scope)[2]}/providers/Microsoft.Authorization/roleDefinitions/${reverse(split("/", value.role_definition_id))[0]}"
          : "/providers/Microsoft.Authorization/roleDefinitions/${reverse(split("/", value.role_definition_id))[0]}"
        )
      }
    )
  }
}
