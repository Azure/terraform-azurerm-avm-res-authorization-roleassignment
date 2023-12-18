<!-- BEGIN_TF_DOCS -->
# Azure Authorization Role Assignment Module

This module is a convenience wrapper around the `azurerm_role_assignment` resource to make it easier to create role assignments at different scopes for different types of principals.

## Features

This module supports both built in and custom role definitions.

This module can be used to create role assignments at following scopes:

- Management Group
- Subscription
- Resource Group
- Resource

This module supports following types of principals:

- User
- Group
- App Registrations (Service Principal)
- System Assigned Managed Identity
- User Assigned Managed Identity

The module provides muliple helper variables to make it easier to find the principal id for different types of principals.

## Usage

The module takes a mapping approach, where you define the principals and role defintions with keys, then map them together to define role assignments. This approach enables you to create role assignments at multiple scopes for multiple principals with multiple methods of finding the principal id.

### Simple Example - Assign a single User account Owner rights to a single Resource Group

In the most basic example, this is how to assign a single user to a resource group with a built in role definition:

```hcl
module "role_assignments" {
  source = "Azure/avm-ptn-authorization-roleassignment/azurerm"
  users_by_user_principal_name = {
    abc = "abc@def.com"
  }
  role_definitions = {
    role1 = "Owner"
  }
  role_assignments_for_resource_group = {
    role_assignment1 = {
      resource_group_name = "rg-example"
      role_assignments = {
        role_assignment_1 = {
          role_definition = "role1"
          users           = ["abc"]
        }
      }
    }
  }
}
```

> NOTE: Although this may seem like a lot of code for this seemingly simple task, it is important to note that we are referring to our user by their user principal name and we are referring to our role definition by it's name. If you were to attempt this same task using the native `azurerm` resources and data sources, you would find that you require at least 3 data sources and 1 resource to achieve the same result.

### Example - Assign multiple principals different roles on a resource group in a different subscription to the one Terraform is configured for

This example demonstrates how to use different principal types and different roles to assign multiple principals to a resource group in a different subscription than the one the provider is configured for. The principal running Terraform would require User Access Administrator rights on the target resource group to be able to assign roles to principals in that subscription.

In this example we are assigning the following roles:

| Role Name | Principal Type | Principal Name |
| --------- | -------------- | -------------- |
| Owner     | User           | <abc@def.com>   |
| Contributor | Group         | my-group       |
| Reader      | App Registration | my-app-registration-1 |
| Contributor | System Assigned Managed Identity | my-app-service |
| Owner       | User Assigned Managed Identity | my-mi-1 |
| Owner       | User Assigned Managed Identity | my-mi-2 |

```hcl
module "role_assignments" {
  source = "Azure/avm-ptn-authorization-roleassignment/azurerm"
  users_by_user_principal_name = {
    abc = "abc@def.com"
  }
  groups_by_display_name = {
    group1 = "my-group"
  }
  app_registrations_by_display_name = {
    app1 = "my-app-registration-1"
  }
  system_assigned_managed_identities_by_display_name = {
    mi1 = "my-app-service"
  }
  user_assigned_managed_identities_by_display_name = {
    mi1 = "my-mi-1" # Note we are using the same key as the system assigned managed identity, this is allowed as they are different types of principals.
    mi2 = "my-mi-2"
  }

  role_definitions = {
    owner       = "Owner"
    contributor = "Contributor"
    reader      = "Reader"
  }

  role_assignments_for_resource_group = {
    role_assignment1 = {
      resource_group_name = "rg-example-2"
      subscription_id     = "7d805431-4943-42ed-8116-3b545c2fc459"
      role_assignments = {
        role_assignment_1 = {
          role_definition                  = "owner"
          users                            = ["abc"]
          user_assigned_managed_identities = ["mi1", "mi2"]
        }
        role_assignment_2 = {
          role_definition                    = "contributor"
          groups                             = ["group1"]
          system_assigned_managed_identities = ["mi1"]
        }
        role_assignment_3 = {
          role_definition   = "reader"
          app_registrations = ["app1"]
        }
      }
    }
  }
}
```

Trigger deployment

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
- [azurerm_role_assignment.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) (resource)
- [random_id.telem](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) (resource)
- [azuread_application.applications_by_client_id](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/application) (data source)
- [azuread_application.applications_by_display_name](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/application) (data source)
- [azuread_application.applications_by_object_id](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/application) (data source)
- [azuread_group.groups_by_display_name](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group) (data source)
- [azuread_group.groups_by_mail_nickname](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group) (data source)
- [azuread_group.groups_by_object_id](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group) (data source)
- [azuread_service_principal.service_principal_by_client_id](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/service_principal) (data source)
- [azuread_service_principal.service_principal_by_object_id](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/service_principal) (data source)
- [azuread_service_principal.system_assigned_managed_identities_by_client_id](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/service_principal) (data source)
- [azuread_service_principal.system_assigned_managed_identities_by_display_name](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/service_principal) (data source)
- [azuread_service_principal.system_assigned_managed_identities_by_principal_id](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/service_principal) (data source)
- [azuread_service_principal.user_assigned_managed_identities_by_client_id](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/service_principal) (data source)
- [azuread_service_principal.user_assigned_managed_identities_by_display_name](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/service_principal) (data source)
- [azuread_service_principal.user_assigned_managed_identities_by_principal_id](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/service_principal) (data source)
- [azuread_user.users_by_employee_id](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/user) (data source)
- [azuread_user.users_by_mail](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/user) (data source)
- [azuread_user.users_by_mail_nickname](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/user) (data source)
- [azuread_user.users_by_object_id](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/user) (data source)
- [azuread_user.users_by_user_principal_name](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/user) (data source)
- [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) (data source)
- [azurerm_resources.resources_by_resource_group_and_name](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resources) (data source)
- [azurerm_role_definition.role_definitions_by_name](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/role_definition) (data source)
- [azurerm_user_assigned_identity.user_assigned_managed_identities_by_resource_group_and_name](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/user_assigned_identity) (data source)

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

### <a name="input_role_assignments_for_resource"></a> [role\_assignments\_by\_resource](#input\_role\_assignments\_by\_resource)

Description: NOTE: Only supports provider subscription

Type:

```hcl
map(object({
    resource_name       = string
    resource_group_name = string
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

### <a name="input_role_assignments_for_resource_group"></a> [role\_assignments\_by\_resource\_group](#input\_role\_assignments\_by\_resource\_group)

Description: n/a

Type:

```hcl
map(object({
    resource_group_name = string
    subscription_id     = optional(string, null)
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

### <a name="input_role_assignments_by_scope"></a> [role\_assignments\_by\_scope](#input\_role\_assignments\_by\_scope)

Description: n/a

Type:

```hcl
map(object({
    scope = string
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
    subscription_id = optional(string, null)
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

### <a name="output_groups"></a> [groups](#output\_groups)

Description: n/a

### <a name="output_role_assignments"></a> [role\_assignments](#output\_role\_assignments)

Description: n/a

### <a name="output_role_defintions"></a> [role\_defintions](#output\_role\_defintions)

Description: n/a

### <a name="output_system_assigned_managed_identities"></a> [system\_assigned\_managed\_identities](#output\_system\_assigned\_managed\_identities)

Description: n/a

### <a name="output_user_assigned_managed_identities"></a> [user\_assigned\_managed\_identities](#output\_user\_assigned\_managed\_identities)

Description: n/a

### <a name="output_users"></a> [users](#output\_users)

Description: n/a

## Modules

No modules.

<!-- markdownlint-disable-next-line MD041 -->
## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the repository. There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
<!-- END_TF_DOCS -->