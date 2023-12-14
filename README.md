<!-- BEGIN_TF_DOCS -->
# terraform-azurerm-avm-template

This is a template repo for Terraform Azure Verified Modules.

Things to do:

1. Set up a GitHub repo environment called `test`.
1. Configure environment protection rule to ensure that approval is required before deploying to this environment.
1. Create a user-assigned managed identity in your test subscription.
1. Create a role assignment for the managed identity on your test subscription, use the minimum required role.
1. Configure federated identity credentials on the user assigned managed identity. Use the GitHub environment.
1. Create the following environment secrets on the `test` environment:
   1. AZURE\_CLIENT\_ID
   1. AZURE\_TENANT\_ID
   1. AZURE\_SUBSCRIPTION\_ID

Major version Zero (0.y.z) is for initial development. Anything MAY change at any time. A module SHOULD NOT be considered stable till at least it is major version one (1.0.0) or greater. Changes will always be via new versions being published and no changes will be made to existing published versions. For more details please go to https://semver.org/

<!-- markdownlint-disable MD033 -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>= 1.3.0)

- <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) (>= 2.46.0)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (>= 3.71.0)

- <a name="requirement_random"></a> [random](#requirement\_random) (>= 3.5.0)

## Providers

The following providers are used by this module:

- <a name="provider_azuread"></a> [azuread](#provider\_azuread) (>= 2.46.0)

- <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) (>= 3.71.0)

- <a name="provider_random"></a> [random](#provider\_random) (>= 3.5.0)

## Resources

The following resources are used by this module:

- [azurerm_resource_group_template_deployment.telemetry](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group_template_deployment) (resource)
- [random_id.telem](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) (resource)
- [azuread_application.applications_by_client_id](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/application) (data source)
- [azuread_application.applications_by_display_name](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/application) (data source)
- [azuread_application.applications_by_object_id](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/application) (data source)
- [azuread_service_principal.service_principal_by_client_id](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/service_principal) (data source)
- [azuread_service_principal.service_principal_by_object_id](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/service_principal) (data source)
- [azuread_user.users_by_employee_id](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/user) (data source)
- [azuread_user.users_by_mail](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/user) (data source)
- [azuread_user.users_by_mail_nickname](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/user) (data source)
- [azuread_user.users_by_object_id](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/user) (data source)
- [azuread_user.users_by_user_principal_name](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/user) (data source)

<!-- markdownlint-disable MD013 -->
## Required Inputs

No required inputs.

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_app_registrations_by_client_id"></a> [app\_registrations\_by\_client\_id](#input\_app\_registrations\_by\_client\_id)

Description: n/a

Type: `map(string)`

Default: `{}`

### <a name="input_app_registrations_by_display_name"></a> [app\_registrations\_by\_display\_name](#input\_app\_registrations\_by\_display\_name)

Description: n/a

Type: `map(string)`

Default: `{}`

### <a name="input_app_registrations_by_object_id"></a> [app\_registrations\_by\_object\_id](#input\_app\_registrations\_by\_object\_id)

Description: n/a

Type: `map(string)`

Default: `{}`

### <a name="input_app_registrations_by_principal_id"></a> [app\_registrations\_by\_principal\_id](#input\_app\_registrations\_by\_principal\_id)

Description: n/a

Type: `map(string)`

Default: `{}`

### <a name="input_enable_telemetry"></a> [enable\_telemetry](#input\_enable\_telemetry)

Description: This variable controls whether or not telemetry is enabled for the module.  
For more information see https://aka.ms/avm/telemetryinfo.  
If it is set to false, then no telemetry will be collected.

Type: `bool`

Default: `true`

### <a name="input_entra_id"></a> [entra\_id](#input\_entra\_id)

Description: n/a

Type:

```hcl
map(object({
    entra_id_tentant_id = string
    role_assignments = map(object({
      role_definition                    = string
      users                              = optional(set(string))
      groups                             = optional(set(string))
      app_registrations                  = optional(set(string))
      system_assigned_managed_identities = optional(set(string))
      user_assigned_managed_identities   = optional(set(string))
    }))
  }))
```

Default: `{}`

### <a name="input_groups_by_display_name"></a> [groups\_by\_display\_name](#input\_groups\_by\_display\_name)

Description: n/a

Type: `map(string)`

Default: `{}`

### <a name="input_groups_by_mail"></a> [groups\_by\_mail](#input\_groups\_by\_mail)

Description: n/a

Type: `map(string)`

Default: `{}`

### <a name="input_groups_by_mail_nickname"></a> [groups\_by\_mail\_nickname](#input\_groups\_by\_mail\_nickname)

Description: n/a

Type: `map(string)`

Default: `{}`

### <a name="input_groups_by_object_id"></a> [groups\_by\_object\_id](#input\_groups\_by\_object\_id)

Description: n/a

Type: `map(string)`

Default: `{}`

### <a name="input_management_groups"></a> [management\_groups](#input\_management\_groups)

Description: n/a

Type:

```hcl
map(object({
    management_group_id = string
    role_assignments = map(object({
      role_definition                    = string
      users                              = optional(set(string))
      groups                             = optional(set(string))
      app_registrations                  = optional(set(string))
      system_assigned_managed_identities = optional(set(string))
      user_assigned_managed_identities   = optional(set(string))
    }))
  }))
```

Default: `{}`

### <a name="input_resource_groups"></a> [resource\_groups](#input\_resource\_groups)

Description: n/a

Type:

```hcl
map(object({
    resource_group_name = string
    subscription_id     = string
    role_assignments = map(object({
      role_definition                    = string
      users                              = optional(set(string))
      groups                             = optional(set(string))
      app_registrations                  = optional(set(string))
      system_assigned_managed_identities = optional(set(string))
      user_assigned_managed_identities   = optional(set(string))
    }))
  }))
```

Default: `{}`

### <a name="input_resources"></a> [resources](#input\_resources)

Description: n/a

Type:

```hcl
map(object({
    resource_name       = string
    resource_group_name = string
    subscription_id     = string
    role_assignments = map(object({
      role_definition                    = string
      users                              = optional(set(string))
      groups                             = optional(set(string))
      app_registrations                  = optional(set(string))
      system_assigned_managed_identities = optional(set(string))
      user_assigned_managed_identities   = optional(set(string))
    }))
  }))
```

Default: `{}`

### <a name="input_role_definitions"></a> [role\_definitions](#input\_role\_definitions)

Description: n/a

Type: `map(string)`

Default: `{}`

### <a name="input_subscriptions"></a> [subscriptions](#input\_subscriptions)

Description: n/a

Type:

```hcl
map(object({
    subscription_id = string
    role_assignments = map(object({
      role_definition                    = string
      users                              = optional(set(string))
      groups                             = optional(set(string))
      app_registrations                  = optional(set(string))
      system_assigned_managed_identities = optional(set(string))
      user_assigned_managed_identities   = optional(set(string))
    }))
  }))
```

Default: `{}`

### <a name="input_system_assigned_managed_identities_by_client_id"></a> [system\_assigned\_managed\_identities\_by\_client\_id](#input\_system\_assigned\_managed\_identities\_by\_client\_id)

Description: n/a

Type: `map(string)`

Default: `{}`

### <a name="input_system_assigned_managed_identities_by_display_name"></a> [system\_assigned\_managed\_identities\_by\_display\_name](#input\_system\_assigned\_managed\_identities\_by\_display\_name)

Description: n/a

Type: `map(string)`

Default: `{}`

### <a name="input_system_assigned_managed_identities_by_principal_id"></a> [system\_assigned\_managed\_identities\_by\_principal\_id](#input\_system\_assigned\_managed\_identities\_by\_principal\_id)

Description: n/a

Type: `map(string)`

Default: `{}`

### <a name="input_telemetry_resource_group_name"></a> [telemetry\_resource\_group\_name](#input\_telemetry\_resource\_group\_name)

Description: The resource group where the telemetry will be deployed.

Type: `string`

Default: `""`

### <a name="input_user_assigned_managed_identities_by_client_id"></a> [user\_assigned\_managed\_identities\_by\_client\_id](#input\_user\_assigned\_managed\_identities\_by\_client\_id)

Description: n/a

Type: `map(string)`

Default: `{}`

### <a name="input_user_assigned_managed_identities_by_display_name"></a> [user\_assigned\_managed\_identities\_by\_display\_name](#input\_user\_assigned\_managed\_identities\_by\_display\_name)

Description: n/a

Type: `map(string)`

Default: `{}`

### <a name="input_user_assigned_managed_identities_by_principal_id"></a> [user\_assigned\_managed\_identities\_by\_principal\_id](#input\_user\_assigned\_managed\_identities\_by\_principal\_id)

Description: n/a

Type: `map(string)`

Default: `{}`

### <a name="input_user_assigned_managed_identities_by_resource_group_and_name"></a> [user\_assigned\_managed\_identities\_by\_resource\_group\_and\_name](#input\_user\_assigned\_managed\_identities\_by\_resource\_group\_and\_name)

Description: n/a

Type:

```hcl
map(object({
    resource_group_name = string
    name                = string
  }))
```

Default: `{}`

### <a name="input_users_by_employee_id"></a> [users\_by\_employee\_id](#input\_users\_by\_employee\_id)

Description: n/a

Type: `map(string)`

Default: `{}`

### <a name="input_users_by_mail"></a> [users\_by\_mail](#input\_users\_by\_mail)

Description: n/a

Type: `map(string)`

Default: `{}`

### <a name="input_users_by_mail_nickname"></a> [users\_by\_mail\_nickname](#input\_users\_by\_mail\_nickname)

Description: n/a

Type: `map(string)`

Default: `{}`

### <a name="input_users_by_object_id"></a> [users\_by\_object\_id](#input\_users\_by\_object\_id)

Description: n/a

Type: `map(string)`

Default: `{}`

### <a name="input_users_by_user_principal_name"></a> [users\_by\_user\_principal\_name](#input\_users\_by\_user\_principal\_name)

Description: n/a

Type: `map(string)`

Default: `{}`

## Outputs

The following outputs are exported:

### <a name="output_app_registrations"></a> [app\_registrations](#output\_app\_registrations)

Description: n/a

### <a name="output_users"></a> [users](#output\_users)

Description: n/a

## Modules

No modules.

<!-- markdownlint-disable-next-line MD041 -->
## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the repository. There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
<!-- END_TF_DOCS -->