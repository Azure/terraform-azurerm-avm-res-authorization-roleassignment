mock_provider "azapi" {
  mock_data "azapi_client_config" {
    defaults = {
      subscription_resource_id = "/subscriptions/00000000-0000-0000-0000-000000000000"
    }
  }
}

mock_provider "azuread" {}

mock_provider "random" {
  mock_resource "random_uuid" {
    defaults = {
      result = "00000000-0000-0000-0000-000000000004"
    }
  }
}

mock_provider "time" {}

mock_provider "azurerm" {
  mock_data "azurerm_client_config" {
    defaults = {
      tenant_id       = "00000000-0000-0000-0000-000000000001"
      subscription_id = "00000000-0000-0000-0000-000000000002"
    }
  }

  mock_data "azurerm_management_group" {
    defaults = {
      id           = "/providers/Microsoft.Management/managementGroups/00000000-0000-0000-0000-000000000001"
      display_name = "Renamed tenant root"
    }
  }
}

mock_provider "azurerm" {
  alias = "alternative"
}

override_module {
  target = module.role_assignments
}

variables {
  enable_telemetry = false
}

run "renamed_tenant_root" {
  command = apply

  module {
    source = "./examples/default"
  }

  providers = {
    azapi               = azapi
    azuread             = azuread
    azurerm             = azurerm
    azurerm.alternative = azurerm.alternative

    random = random
    time   = time
  }

  variables {
    test_management_group_display_name = null
  }

  plan_options {
    target = [data.azurerm_client_config.current, azurerm_management_group.test, azurerm_resource_group.test, azurerm_static_web_app.test]
  }

  assert {
    condition     = data.azurerm_management_group.test.name == data.azurerm_client_config.current.tenant_id
    error_message = "A null display name must identify the tenant root by tenant ID."
  }

  assert {
    condition     = data.azurerm_management_group.test.display_name == "Renamed tenant root"
    error_message = "A renamed tenant root must remain usable."
  }

  assert {
    condition     = azurerm_management_group.test.parent_management_group_id == data.azurerm_management_group.test.id
    error_message = "The example management group must retain the selected parent."
  }

  assert {
    condition     = output.test_resource_ids.subscription == "/subscriptions/00000000-0000-0000-0000-000000000002"
    error_message = "Without an alternative subscription, the example output must use the active subscription."
  }
}

run "explicit_management_group_display_name" {
  command = apply

  module {
    source = "./examples/default"
  }

  providers = {
    azapi               = azapi
    azuread             = azuread
    azurerm             = azurerm
    azurerm.alternative = azurerm.alternative

    random = random
    time   = time
  }

  variables {
    alternative_subscription_id        = "00000000-0000-0000-0000-000000000003"
    test_management_group_display_name = "Existing test parent"
  }

  override_data {
    target = data.azurerm_management_group.test
    values = {
      id   = "/providers/Microsoft.Management/managementGroups/existing-test-parent"
      name = "existing-test-parent"
    }
  }

  plan_options {
    target = [data.azurerm_client_config.current, azurerm_management_group.test, azurerm_resource_group.test, azurerm_static_web_app.test]
  }

  assert {
    condition     = data.azurerm_management_group.test.display_name == "Existing test parent"
    error_message = "An explicitly configured display-name lookup must be preserved."
  }

  assert {
    condition     = azurerm_management_group.test.parent_management_group_id == "/providers/Microsoft.Management/managementGroups/existing-test-parent"
    error_message = "An explicit parent must not be replaced by the tenant root."
  }

  assert {
    condition     = output.test_resource_ids.subscription == "/subscriptions/00000000-0000-0000-0000-000000000003"
    error_message = "An explicitly configured alternative subscription must remain in the example output."
  }
}

run "default_parent_and_custom_role" {
  command = apply

  module {
    source = "./examples/default"
  }

  providers = {
    azapi               = azapi
    azuread             = azuread
    azurerm             = azurerm
    azurerm.alternative = azurerm.alternative

    random = random
    time   = time
  }

  override_data {
    target = data.azurerm_management_group.test
    values = {
      id   = "/providers/Microsoft.Management/managementGroups/avm-test"
      name = "avm-test"
    }
  }

  plan_options {
    target = [azapi_resource.test_role_definition]
  }

  assert {
    condition     = data.azurerm_management_group.test.display_name == "AVM Tests" && azapi_resource.test_role_definition[0].parent_id == data.azurerm_management_group.test.id
    error_message = "The default custom role must be created under the AVM Tests management group."
  }

  assert {
    condition     = azapi_resource.test_role_definition[0].body.properties.assignableScopes == [data.azurerm_management_group.test.id]
    error_message = "The custom role must be assignable at the selected parent scope."
  }

  assert {
    condition     = azapi_resource.test_role_definition[0].body.properties.roleName == "Example-Role-${random_uuid.test_role_definition[0].result}"
    error_message = "The custom role name must be unique to the test."
  }
}

run "custom_role_disabled" {
  command = apply

  module {
    source = "./examples/default"
  }

  providers = {
    azapi               = azapi
    azuread             = azuread
    azurerm             = azurerm
    azurerm.alternative = azurerm.alternative

    random = random
    time   = time
  }

  variables {
    include_custom_role_definition = false
  }

  plan_options {
    target = [azapi_resource.test_role_definition]
  }

  assert {
    condition     = length(azapi_resource.test_role_definition) == 0 && length(random_uuid.test_role_definition) == 0
    error_message = "Disabling the custom role must not create a custom role or its identifier."
  }
}
