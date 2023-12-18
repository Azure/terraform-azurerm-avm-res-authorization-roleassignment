<!-- BEGIN_TF_DOCS -->
# Default example

This is an end to end example demonstrating the full functionlality of the module.

Since this module requires specific account name, this example creates them dynamically so we can use it for end to end testing without any specific dependencies.

Having said that, there is one specific dependency on a custom role definition called `Example-Role` in this example. This is due to the very slow API response when creating role definitions, which makes it unsuitable for end to end testing.

```hcl
module "avm-ptn-authorization-roleassignment" {
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
```

<!-- markdownlint-disable MD033 -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>= 1.3.0)

- <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) (>= 2.0.0, < 3.0.0)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (>= 3.7.0, < 4.0.0)

- <a name="requirement_random"></a> [random](#requirement\_random) (>= 3.0.0)

- <a name="requirement_time"></a> [time](#requirement\_time) (>= 0.7.0)

## Providers

The following providers are used by this module:

- <a name="provider_azuread"></a> [azuread](#provider\_azuread) (>= 2.0.0, < 3.0.0)

- <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) (>= 3.7.0, < 4.0.0)

- <a name="provider_azurerm.alternative"></a> [azurerm.alternative](#provider\_azurerm.alternative) (>= 3.7.0, < 4.0.0)

- <a name="provider_random"></a> [random](#provider\_random) (>= 3.0.0)

- <a name="provider_time"></a> [time](#provider\_time) (>= 0.7.0)

## Resources

The following resources are used by this module:

- [azuread_application.test](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application) (resource)
- [azuread_group.test](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/group) (resource)
- [azuread_service_principal.test](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/service_principal) (resource)
- [azuread_user.test](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/user) (resource)
- [azurerm_management_group.test](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/management_group) (resource)
- [azurerm_resource_group.alternative](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) (resource)
- [azurerm_resource_group.test](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) (resource)
- [azurerm_static_site.test](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/static_site) (resource)
- [azurerm_user_assigned_identity.test](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) (resource)
- [random_password.password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) (resource)
- [random_pet.app_registration_display_name](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/pet) (resource)
- [random_pet.group_name](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/pet) (resource)
- [random_pet.management_group_name](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/pet) (resource)
- [random_pet.resource_group_name](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/pet) (resource)
- [random_pet.static_site](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/pet) (resource)
- [random_pet.user_assigned_managed_identity](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/pet) (resource)
- [random_pet.username](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/pet) (resource)
- [random_string.employee_id](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) (resource)
- [time_sleep.before_service_principal_read_creation](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) (resource)
- [azuread_service_principal.test](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/service_principal) (data source)
- [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) (data source)
- [azurerm_management_group.test](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/management_group) (data source)

<!-- markdownlint-disable MD013 -->
## Required Inputs

No required inputs.

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_alternative_subscription_id"></a> [alternative\_subscription\_id](#input\_alternative\_subscription\_id)

Description: This variable is used to test the module with an alternative subscription id.

Type: `string`

Default: `null`

### <a name="input_enable_telemetry"></a> [enable\_telemetry](#input\_enable\_telemetry)

Description: This variable controls whether or not telemetry is enabled for the module.  
For more information see https://aka.ms/avm/telemetryinfo.  
If it is set to false, then no telemetry will be collected.

Type: `bool`

Default: `true`

### <a name="input_include_custom_role_definition"></a> [include\_custom\_role\_definition](#input\_include\_custom\_role\_definition)

Description: This variable is used to control whether the example tests a custom role definition.

Type: `bool`

Default: `true`

### <a name="input_spn_domain"></a> [spn\_domain](#input\_spn\_domain)

Description: The domain name that is post-fixed on the service principal name.  
This must be a valid domain registered in your Entra ID tenant.

Type: `string`

Default: `"changeme.com"`

### <a name="input_test_management_group_display_name"></a> [test\_management\_group\_display\_name](#input\_test\_management\_group\_display\_name)

Description: The display name for the management group to test.

Type: `string`

Default: `"Tenant Root Group"`

## Outputs

The following outputs are exported:

### <a name="output_all_principals"></a> [all\_principals](#output\_all\_principals)

Description: n/a

### <a name="output_app_registrations"></a> [app\_registrations](#output\_app\_registrations)

Description: n/a

### <a name="output_entra_id_role_assignments"></a> [entra\_id\_role\_assignments](#output\_entra\_id\_role\_assignments)

Description: n/a

### <a name="output_entra_id_role_definitions"></a> [entra\_id\_role\_definitions](#output\_entra\_id\_role\_definitions)

Description: n/a

### <a name="output_groups"></a> [groups](#output\_groups)

Description: n/a

### <a name="output_role_assignments"></a> [role\_assignments](#output\_role\_assignments)

Description: n/a

### <a name="output_role_defintions"></a> [role\_defintions](#output\_role\_defintions)

Description: n/a

### <a name="output_system_assigned_managed_identities"></a> [system\_assigned\_managed\_identities](#output\_system\_assigned\_managed\_identities)

Description: n/a

### <a name="output_test_resource_ids"></a> [test\_resource\_ids](#output\_test\_resource\_ids)

Description: n/a

### <a name="output_user_assigned_managed_identities"></a> [user\_assigned\_managed\_identities](#output\_user\_assigned\_managed\_identities)

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