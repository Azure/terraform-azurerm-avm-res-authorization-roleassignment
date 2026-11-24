terraform {
  required_version = "~> 1.6"

  required_providers {
    azapi = {
      source  = "Azure/azapi"
      version = "~> 2.12"
    }
    # tflint-ignore: terraform_unused_required_providers
    azuread = {
      source  = "hashicorp/azuread"
      version = ">= 2.46, < 4.0"
    }
  }
}

data "azapi_client_config" "current" {}

# The test identity is the principal, so the example needs no Microsoft Graph write permissions. These roles differ from the default example so concurrent runs in one subscription do not collide.
module "role_assignments" {
  source = "../../"

  location = var.location
  # source = "Azure/avm-ptn-authorization-roleassignment/azurerm"
  enable_telemetry = var.enable_telemetry
  role_assignments_azure_resource_manager = {
    monitoring_reader_by_id = {
      principal_id       = data.azapi_client_config.current.object_id
      principal_type     = "ServicePrincipal"
      role_definition_id = "/subscriptions/${data.azapi_client_config.current.subscription_id}/providers/Microsoft.Authorization/roleDefinitions/43d0d8ad-25c7-4714-9337-8ba259a9fe05"
      scope              = "/subscriptions/${data.azapi_client_config.current.subscription_id}"
    }
    log_analytics_reader_by_name = {
      principal_id         = data.azapi_client_config.current.object_id
      role_definition_name = "Log Analytics Reader"
      scope                = "/subscriptions/${data.azapi_client_config.current.subscription_id}"
    }
  }
}
