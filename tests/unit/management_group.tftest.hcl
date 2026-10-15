mock_provider "azapi" {}
mock_provider "azuread" {}
mock_provider "modtm" {}
mock_provider "random" {}
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
    modtm               = modtm
    random              = random
    time                = time
  }

  plan_options {
    target = [data.azurerm_client_config.current, azurerm_management_group.test]
  }

  assert {
    condition     = data.azurerm_management_group.test.name == data.azurerm_client_config.current.tenant_id
    error_message = "The default lookup must identify the tenant root by tenant ID."
  }

  assert {
    condition     = data.azurerm_management_group.test.display_name == "Renamed tenant root"
    error_message = "A renamed tenant root must remain usable."
  }

  assert {
    condition     = azurerm_management_group.test.parent_management_group_id == data.azurerm_management_group.test.id
    error_message = "The example management group must retain the selected parent."
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
    modtm               = modtm
    random              = random
    time                = time
  }

  variables {
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
    target = [data.azurerm_client_config.current, azurerm_management_group.test]
  }

  assert {
    condition     = data.azurerm_management_group.test.display_name == "Existing test parent"
    error_message = "An explicitly configured display-name lookup must be preserved."
  }

  assert {
    condition     = azurerm_management_group.test.parent_management_group_id == "/providers/Microsoft.Management/managementGroups/existing-test-parent"
    error_message = "An explicit parent must not be replaced by the tenant root."
  }
}
