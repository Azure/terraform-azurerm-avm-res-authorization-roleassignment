data "azapi_client_config" "current" {}

resource "random_pet" "resource_group_name" {
  length    = 2
  separator = "-"
}

resource "azapi_resource" "resource_group" {
  location               = var.location
  name                   = "apar-upgrade-${random_pet.resource_group_name.id}"
  parent_id              = "/subscriptions/${data.azapi_client_config.current.subscription_id}"
  type                   = "Microsoft.Resources/resourceGroups@2025-04-01"
  response_export_values = []
}

# Find the test subscription's parent management group, where the test identity inherits access.
data "azapi_resource_action" "subscription_management_groups" {
  action      = "resources"
  method      = "POST"
  resource_id = "/providers/Microsoft.ResourceGraph"
  type        = "Microsoft.ResourceGraph@2022-10-01"
  body = {
    subscriptions = [data.azapi_client_config.current.subscription_id]
    query         = "resourcecontainers | where type == 'microsoft.resources/subscriptions' | project chain = properties.managementGroupAncestorsChain"
  }
  response_export_values = {
    parent = "data[0].chain[0].name"
  }
}

# pre.ps1 deploys this configuration with v0.3.1 of the module first, then the E2E run applies it with this version over the same state.
# Every role is unique to this example so concurrent example runs in one subscription do not collide.
module "role_assignments" {
  source = "../../"

  location = var.location # Not supported by v0.3.1; pre.ps1 removes this line.
  app_registrations_by_principal_id = {
    test_identity = data.azapi_client_config.current.object_id
  }
  enable_telemetry = var.enable_telemetry
  role_assignments_azure_resource_manager = {
    cost_management_reader = {
      principal_id         = data.azapi_client_config.current.object_id
      role_definition_name = "Cost Management Reader"
      scope                = "/subscriptions/${data.azapi_client_config.current.subscription_id}"
    }
  }
  role_assignments_for_resource_groups = {
    test = {
      resource_group_name = azapi_resource.resource_group.name
      role_assignments = {
        reader = {
          role_definition = "reader"
          any_principals  = ["test_identity"]
        }
      }
    }
  }
  role_assignments_for_scopes = {
    parent_management_group = {
      scope = "/providers/Microsoft.Management/managementGroups/${data.azapi_resource_action.subscription_management_groups.output.parent}"
      role_assignments = {
        monitoring_reader = {
          role_definition   = "monitoring_reader"
          app_registrations = ["test_identity"]
        }
      }
    }
  }
  role_assignments_for_subscriptions = {
    test = {
      role_assignments = {
        billing_reader = {
          role_definition   = "billing_reader"
          app_registrations = ["test_identity"]
        }
      }
    }
  }
  role_definitions = {
    billing_reader    = { name = "Billing Reader" }
    monitoring_reader = { name = "Monitoring Reader" }
    reader            = { name = "Reader" }
  }
}
