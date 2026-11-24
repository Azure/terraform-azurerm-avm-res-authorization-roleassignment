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
    role_assignments_for_scopes = {
      test = {
        scope = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-rg"
        role_assignments = {
          reader = {
            role_definition                  = "reader"
            user_assigned_managed_identities = ["test-uami"]
          }
        }
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
    condition     = contains(azapi_resource.basic["basic-reader"].replace_triggers_external_values, "/subscriptions/00000000-0000-0000-0000-000000000000/providers/Microsoft.Authorization/roleDefinitions/acdd72a7-3385-48ef-bd42-f606fba81ae7")
    error_message = "The basic assignment replacement trigger must use the resolved role definition ID."
  }

  assert {
    condition = (
      contains(azapi_resource.this["scope-uami-test-reader-test-uami"].replace_triggers_external_values, "11111111-1111-1111-1111-111111111111") &&
      contains(azapi_resource.this["scope-uami-test-reader-test-uami"].replace_triggers_external_values, "/subscriptions/00000000-0000-0000-0000-000000000000/providers/Microsoft.Authorization/roleDefinitions/acdd72a7-3385-48ef-bd42-f606fba81ae7")
    )
    error_message = "The standard assignment replacement triggers must use the resolved principal and role definition IDs."
  }

  assert {
    condition     = output.user_assigned_managed_identities["test-uami"] == "11111111-1111-1111-1111-111111111111"
    error_message = "The user-assigned managed identity name lookup should read the AzAPI resource list output.value."
  }
}

run "legacy_entra_alias_preserves_flattened_shape_and_scopes" {
  command = apply

  variables {
    entra_id_role_definitions = {
      reader = {
        template_id = "aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa"
      }
    }
    role_assignments_for_entra_id = {
      normal = {
        role_assignments = {
          reader = {
            role_definition     = "reader"
            principal_object_id = "55555555-5555-5555-5555-555555555555"
          }
        }
      }
    }
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
    condition     = azuread_directory_role_assignment.basic["legacy-app-reader"].app_scope_id == "/app/legacy-app"
    error_message = "The legacy app scope should be passed to the directory role assignment."
  }

  assert {
    condition     = azuread_directory_role_assignment.basic["legacy-directory-reader"].directory_scope_id == "/administrativeUnits/aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa"
    error_message = "The legacy directory scope should be passed to the directory role assignment."
  }

  assert {
    condition     = contains(keys(azuread_directory_role_assignment.this), "entraid-principal-normal-reader") && !contains(keys(azuread_directory_role_assignment.this), "legacy-app-reader") && contains(keys(azuread_directory_role_assignment.basic), "legacy-app-reader")
    error_message = "Regular and legacy Entra assignments must retain their separate state addresses."
  }
}

run "role_assignment_identity_changes_trigger_replacement" {
  command = plan

  variables {
    role_assignments_azure_resource_manager = {
      reader = {
        principal_id       = "55555555-5555-5555-5555-555555555555"
        scope              = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-rg"
        role_definition_id = "/subscriptions/00000000-0000-0000-0000-000000000000/providers/Microsoft.Authorization/roleDefinitions/acdd72a7-3385-48ef-bd42-f606fba81ae7"
      }
    }
    role_assignments_entra_id = {
      legacy = {
        principal_object_id = "66666666-6666-6666-6666-666666666666"
        role_id             = "bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb"
      }
    }
  }

  assert {
    condition     = contains(azapi_resource.basic["reader"].replace_triggers_external_values, "55555555-5555-5555-5555-555555555555")
    error_message = "A principal change must replace the role assignment."
  }

  assert {
    condition     = contains(azapi_resource.basic["reader"].replace_triggers_external_values, "/subscriptions/00000000-0000-0000-0000-000000000000/providers/Microsoft.Authorization/roleDefinitions/acdd72a7-3385-48ef-bd42-f606fba81ae7")
    error_message = "A role definition change must replace the role assignment."
  }

  assert {
    condition     = contains(keys(azuread_directory_role_assignment.basic), "legacy") && !contains(keys(azuread_directory_role_assignment.this), "legacy")
    error_message = "Legacy Entra ID assignments must stay on azuread_directory_role_assignment.basic."
  }

  assert {
    condition     = contains(keys(output.entra_id_role_assignments), "legacy")
    error_message = "The entra_id_role_assignments output should still include legacy assignments."
  }
}

run "resource_scope_lookup_uses_resource_group_resources_endpoint" {
  command = apply

  variables {
    role_definitions = {
      reader = {
        name = "Reader"
      }
    }
    role_assignments_for_resources = {
      app = {
        resource_group_name = "test-rg"
        resource_name       = "test-app"
        role_assignments = {
          reader = {
            role_definition = "reader"
            any_principals  = []
          }
        }
      }
    }
  }

  override_data {
    target = data.azapi_resource_action.resources_by_resource_group_and_name["app"]
    values = {
      output = {
        value = [
          {
            id   = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-rg/providers/Microsoft.Web/sites/test-app"
            name = "test-app"
          }
        ]
      }
    }
  }

  assert {
    condition = (
      data.azapi_resource_action.resources_by_resource_group_and_name["app"].resource_id == "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-rg" &&
      data.azapi_resource_action.resources_by_resource_group_and_name["app"].action == "resources" &&
      data.azapi_resource_action.resources_by_resource_group_and_name["app"].method == "GET"
    )
    error_message = "The resource lookup must call the resource group's resources endpoint."
  }

  assert {
    condition     = local.resource_ids_by_resource_group_and_name["app"] == "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-rg/providers/Microsoft.Web/sites/test-app"
    error_message = "The resource lookup should resolve the resource ID from output.value."
  }
}