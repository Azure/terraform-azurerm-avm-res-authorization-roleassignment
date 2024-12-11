<!-- BEGIN_TF_DOCS -->
# Basic example

This is an end to end example demonstrating the full functionlality of the module.

Since this module requires specific account name, this example creates them dynamically so we can use it for end to end testing without any specific dependencies.

Having said that, there is one specific dependency on a custom role definition called `Example-Role` in this example. This is due to the very slow API response when creating role definitions, which makes it unsuitable for end to end testing.

```hcl
terraform {
  required_version = "~> 1.6"
  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.46"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.7, < 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
  }
}

provider "azurerm" {
  features {}
}

variable "spn_domain" {
  type        = string
  default     = "changeme.com"
  description = <<DESCRIPTION
The domain name that is post-fixed on the service principal name.
This must be a valid domain registered in your Entra ID tenant.
DESCRIPTION
}

locals {
  module_name = "apar"
  users = {
    user1 = "user1"
    user2 = "user2"
    user3 = "user3"
    user4 = "user4"
    user5 = "user5"
    user6 = "user6"
    user7 = "user7"
    user8 = "user8"
  }
}

resource "random_pet" "username" {
  for_each = local.users

  length    = 2
  separator = "-"
}

resource "random_password" "password" {
  for_each = local.users

  length           = 20
  min_lower        = 1
  min_numeric      = 1
  min_special      = 1
  min_upper        = 1
  override_special = "_%@"
  special          = true
}

resource "random_string" "employee_id" {
  for_each = local.users

  length  = 10
  lower   = false
  numeric = true
  special = false
  upper   = false
}

resource "azuread_user" "test" {
  for_each = local.users

  display_name        = "${local.module_name}-${each.key}-${random_pet.username[each.key].id}"
  user_principal_name = "${each.key}-${random_pet.username[each.key].id}@${var.spn_domain}"
  account_enabled     = false
  employee_id         = random_string.employee_id[each.key].result
  mail                = "${each.key}-${random_pet.username[each.key].id}@avm-test.com"
  mail_nickname       = "${each.key}-${random_pet.username[each.key].id}"
  password            = random_password.password[each.key].result
}

data "azurerm_client_config" "current" {}

module "role_assignments" {
  source = "../../"
  # source = "Azure/avm-ptn-authorization-roleassignment/azurerm"
  enable_telemetry = false

  role_assignments_azure_resource_manager = {
    for key, value in local.users : key => {
      principal_id         = azuread_user.test[key].object_id
      role_definition_name = "Owner"
      scope                = "/subscriptions/${data.azurerm_client_config.current.subscription_id}"
    }
  }

  role_assignments_entra_id = {
    for key, value in local.users : key => {
      principal_object_id = azuread_user.test[key].object_id
      role_id             = "9b895d92-2cd3-44c7-9d02-a6ac2d5ea5c3"
    }
  }
}
```

<!-- markdownlint-disable MD033 -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (~> 1.6)

- <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) (~> 2.46)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (>= 3.7, < 5.0)

- <a name="requirement_random"></a> [random](#requirement\_random) (~> 3.5)

## Resources

The following resources are used by this module:

- [azuread_user.test](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/user) (resource)
- [random_password.password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) (resource)
- [random_pet.username](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/pet) (resource)
- [random_string.employee_id](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) (resource)
- [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) (data source)

<!-- markdownlint-disable MD013 -->
## Required Inputs

No required inputs.

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_spn_domain"></a> [spn\_domain](#input\_spn\_domain)

Description: The domain name that is post-fixed on the service principal name.  
This must be a valid domain registered in your Entra ID tenant.

Type: `string`

Default: `"changeme.com"`

## Outputs

No outputs.

## Modules

The following Modules are called:

### <a name="module_role_assignments"></a> [role\_assignments](#module\_role\_assignments)

Source: ../../

Version:

<!-- markdownlint-disable-next-line MD041 -->
## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the repository. There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
<!-- END_TF_DOCS -->