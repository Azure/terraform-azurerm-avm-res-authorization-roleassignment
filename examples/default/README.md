<!-- BEGIN_TF_DOCS -->
# Default example

This deploys the module in its simplest form.

```hcl
terraform {
  required_version = ">= 1.3.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.7.0, < 4.0.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = ">= 2.0.0, < 3.0.0"
    }
  }
}

provider "azurerm" {
  features {}
}

locals {
  module_name                 = "avm-ptn-authorization-roleassignment"
  test_user_count             = 6
  test_app_registrstion_count = 5
}

module "avm-ptn-authorization-roleassignment" {
  source = "../../"
  # source = "Azure/avm-ptn-authorization-roleassignment/azurerm"
  enable_telemetry = var.enable_telemetry

  depends_on = [azuread_service_principal.test, azuread_user.test]

  users_by_user_principal_name = {
    user1 = azuread_user.test[0].user_principal_name
    user2 = azuread_user.test[1].user_principal_name
  }
  users_by_mail = {
    user1 = azuread_user.test[0].mail
    user3 = azuread_user.test[2].mail
  }
  users_by_mail_nickname = {
    user1 = azuread_user.test[0].mail_nickname
    user4 = azuread_user.test[3].mail_nickname
  }
  users_by_employee_id = {
    user1 = azuread_user.test[0].employee_id
    user5 = azuread_user.test[4].employee_id
  }
  users_by_object_id = {
    user1 = azuread_user.test[0].object_id
    user6 = azuread_user.test[5].object_id
  }

  app_registrations_by_display_name = {
    app1 = azuread_application.test[0].display_name
    app2 = azuread_application.test[1].display_name
  }
  app_registrations_by_client_id = {
    app1 = azuread_application.test[0].client_id
    app3 = azuread_application.test[2].client_id
  }
  app_registrations_by_object_id = {
    app1 = azuread_application.test[0].object_id
    app4 = azuread_application.test[3].object_id
  }
  app_registrations_by_principal_id = {
    app1 = azuread_service_principal.test[0].object_id
    app5 = azuread_service_principal.test[4].object_id
  }
}


```

<!-- markdownlint-disable MD033 -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>= 1.3.0)

- <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) (>= 2.0.0, < 3.0.0)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (>= 3.7.0, < 4.0.0)

## Providers

The following providers are used by this module:

- <a name="provider_azuread"></a> [azuread](#provider\_azuread) (>= 2.0.0, < 3.0.0)

- <a name="provider_random"></a> [random](#provider\_random)

## Resources

The following resources are used by this module:

- [azuread_application.test](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application) (resource)
- [azuread_service_principal.test](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/service_principal) (resource)
- [azuread_user.test](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/user) (resource)
- [random_password.password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) (resource)
- [random_pet.app_registration_display_name](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/pet) (resource)
- [random_pet.username](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/pet) (resource)
- [random_string.employee_id](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) (resource)

<!-- markdownlint-disable MD013 -->
## Required Inputs

No required inputs.

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_enable_telemetry"></a> [enable\_telemetry](#input\_enable\_telemetry)

Description: This variable controls whether or not telemetry is enabled for the module.  
For more information see https://aka.ms/avm/telemetryinfo.  
If it is set to false, then no telemetry will be collected.

Type: `bool`

Default: `true`

### <a name="input_spn_domain"></a> [spn\_domain](#input\_spn\_domain)

Description: The domain name for the service principal name.

Type: `string`

Default: `"changeme.com"`

## Outputs

The following outputs are exported:

### <a name="output_app_registrations"></a> [app\_registrations](#output\_app\_registrations)

Description: n/a

### <a name="output_users"></a> [users](#output\_users)

Description: n/a

## Modules

The following Modules are called:

### <a name="module_avm-ptn-authorization-roleassignment"></a> [avm-ptn-authorization-roleassignment](#module\_avm-ptn-authorization-roleassignment)

Source: ../../

Version:

<!-- markdownlint-disable-next-line MD041 -->
## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the repository. There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
<!-- END_TF_DOCS -->