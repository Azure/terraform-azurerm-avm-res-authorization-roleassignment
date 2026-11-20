mock_provider "azapi" {
  mock_data "azapi_client_config" {
    defaults = {
      subscription_id          = "00000000-0000-0000-0000-000000000000"
      tenant_id                = "00000000-0000-0000-0000-000000000001"
      subscription_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000"
    }
  }

  mock_data "azapi_resource_list" {
    defaults = {
      output = {
        value = [
          {
            id   = "/subscriptions/00000000-0000-0000-0000-000000000000/providers/Microsoft.Authorization/roleDefinitions/acdd72a7-3385-48ef-bd42-f606fba81ae7"
            name = "acdd72a7-3385-48ef-bd42-f606fba81ae7"
            properties = {
              roleName         = "Reader"
              assignableScopes = ["/"]
            }
          },
          {
            id   = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/test-uami"
            name = "test-uami"
            properties = {
              principalId = "11111111-1111-1111-1111-111111111111"
            }
          }
        ]
      }
    }
  }
}

mock_provider "azuread" {}

variables {
  enable_telemetry = false
  location         = "eastus"
}

run "azapi_name_lookups_resolve_output_value" {
  command = apply

  variables {
    role_definitions = {
      reader = {
        name = "Reader"
      }
    }
    role_assignments_azure_resource_manager = {
      basic-reader = {
        principal_id         = "22222222-2222-2222-2222-222222222222"
        scope                = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-rg"
        role_definition_name = "Reader"
      }
    }
    user_assigned_managed_identities_by_resource_group_and_name = {
      test-uami = {
        resource_group_name = "test-rg"
        name                = "test-uami"
      }
    }
  }

  assert {
    condition     = output.role_definitions.reader.id == "/subscriptions/00000000-0000-0000-0000-000000000000/providers/Microsoft.Authorization/roleDefinitions/acdd72a7-3385-48ef-bd42-f606fba81ae7"
    error_message = "The Reader role definition name lookup should read the AzAPI resource list output.value."
  }

  assert {
    condition     = output.role_assignments["basic-basic-reader"].role_definition_id == "/subscriptions/00000000-0000-0000-0000-000000000000/providers/Microsoft.Authorization/roleDefinitions/acdd72a7-3385-48ef-bd42-f606fba81ae7"
    error_message = "The basic role assignment name lookup should read the AzAPI resource list output.value."
  }

  assert {
    condition     = output.user_assigned_managed_identities["test-uami"] == "11111111-1111-1111-1111-111111111111"
    error_message = "The user-assigned managed identity name lookup should read the AzAPI resource list output.value."
  }
}

run "legacy_entra_alias_preserves_flattened_shape_and_scopes" {
  command = apply

  variables {
    role_assignments_entra_id = {
      legacy-app-reader = {
        app_scope_id        = "/app/legacy-app"
        principal_object_id = "33333333-3333-3333-3333-333333333333"
        role_id             = "bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb"
      }
      legacy-directory-reader = {
        directory_scope_id  = "/administrativeUnits/aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa"
        principal_object_id = "44444444-4444-4444-4444-444444444444"
        role_id             = "bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb"
      }
    }
  }

  assert {
    condition     = output.entra_id_role_assignments["legacy-app-reader"].principal_id == "33333333-3333-3333-3333-333333333333"
    error_message = "The legacy Entra alias should be flattened to principal_id."
  }

  assert {
    condition     = output.entra_id_role_assignments["legacy-app-reader"].role_definition_id == "bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb"
    error_message = "The legacy Entra alias should be flattened to role_definition_id."
  }

  assert {
    condition     = azuread_directory_role_assignment.this["legacy-app-reader"].app_scope_id == "/app/legacy-app"
    error_message = "The legacy app scope should be passed to the directory role assignment."
  }

  assert {
    condition     = azuread_directory_role_assignment.this["legacy-directory-reader"].directory_scope_id == "/administrativeUnits/aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa"
    error_message = "The legacy directory scope should be passed to the directory role assignment."
  }
}
