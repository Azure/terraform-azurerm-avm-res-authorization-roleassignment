<!-- BEGIN_TF_DOCS -->
# Azure Authorization Role Assignment Module

This module is a convenience wrapper around the `azurerm_role_assignment` resource to make it easier to create role assignments at different scopes for different types of principals.

TLDR: Skip to our [Examples](#examples) section for common usage patterns.

## Features

This module supports both built in and custom role definitions.

This module can be used to create role assignments at the following scopes:

- Entra ID
- Management Group
- Subscription
- Resource Group
- Resource

This module supports the following types of principals:

- User
- Group
- App Registrations (Service Principal)
- System Assigned Managed Identity
- User Assigned Managed Identity

The module provides multiple helper variables to make it easier to find the principal id (object id) for different types of principals.

>NOTE: The module does not create the principals or role definitions for you, you must create them yourself. The module only creates the role assignments.

## Usage

The module takes a mapping approach, where you define the principals and role definitions with keys, then map them together to define role assignments. This approach enables you to create role assignments at multiple scopes for multiple principals with multiple methods of finding the principal id.

### Approach

The following steps outline the approach to using this module:

1. Define the principals
2. Define the role definitions
3. Map the principals to the role definitions at a specific scope

#### 1 - Define the principals

There are different method to find each type of prinicpal, each has a different variable. These are combined together into a single map in the module, so you can refer to them by their key in the role assignment variables. As such, you can use multiple variable for the same type of principal, as long as the keys are unique.

>NOTE: If the keys are not unique, then the principals will be merged based on the key in the precedence order of the variables shown here.

For a User principal you have the following options:

- `users_by_user_principal_name`: Find users by their user principal name (UPN).
- `users_by_mail`: Find users by their mail address.
- `users_by_mail_nickname`: Find users by their mail nickname.
- `users_by_employee_id`: Find users by their employee id.
- `users_by_object_id`: Find users by their object id.

For a Group principal you have the following options:

- `groups_by_display_name`: Find groups by their display name.
- `groups_by_mail_nickname`: Find groups by their mail nickname.
- `groups_by_object_id`: Find groups by their object id.

For an App Registration principal you have the following options:

- `app_registrations_by_display_name`: Find app registrations by their display name.
- `app_registrations_by_client_id`: Find app registrations by their client id (application id).
- `app_registrations_by_object_id`: Find app registrations by their object id.
- `app_registrations_by_principal_id`: Find app registrations by the principal id of the underpinning Service Principal.

For a System Assigned Managed Identity principal you have the following options:

- `system_assigned_managed_identities_by_display_name`: Find system assigned managed identities by their display name.
- `system_assigned_managed_identities_by_client_id`: Find system assigned managed identities by their client id (application id).
- `system_assigned_managed_identities_by_principal_id`: Find system assigned managed identities by their principal id of the underpinning Service Principal.

For a User Assigned Managed Identity principal you have the following options:

- `user_assigned_managed_identities_by_resource_group_and_name`: Find user assigned managed identities by their resource group and name.
- `user_assigned_managed_identities_by_display_name`: Find user assigned managed identities by their display name.
- `user_assigned_managed_identities_by_client_id`: Find user assigned managed identities by their client id (application id).
- `user_assigned_managed_identities_by_principal_id`: Find user assigned managed identities by their principal id of the underpinning Service Principal.

#### 2 - Define the role definitions

You can use either built in or custom role definitions. There are two variables used to find role definitions:

- `role_definitions`: Find Azure Resource Manager role definitions by their name.
- `entra_id_role_definitions`: Find Entra ID role definitions by their name.

#### 3 - Map the principals to the role definitions at a specific scope

There are several variables that can be used to map the principals to the role definitions at a specific scope:

- `role_assignments_for_entra_id`: Map principals to role definitions in Entra ID. This only works in the context of the current tenant.
- `role_assignments_for_management_groups`: Map principals to role definitions at the management group scope.
- `role_assignments_for_subscriptions`: Map principals to role definitions at the subscription scope. This works cross-subscription.
- `role_assignments_for_resource_groups`: Map principals to role definitions at the resource group scope. This works cross-subscription.
- `role_assignments_for_resources`: Map principals to role definitions at the resource scope. This only works in the scope of the current subscription.
- `role_assignments_for_scopes`: Map principals to role definitions at any scope. This is a catch all and you must supply the scope / resource id. This works cross-subscription.

## Examples

The following examples show common usage patterns:

- [Simple Example - Assign a single User account Owner rights to a single Resource Group](#simple-example---assign-a-single-user-account-owner-rights-to-a-single-resource-group)
- [Example - Assign multiple principals different roles on a resource group in a different subscription to the one Terraform is configured for](#example---assign-multiple-principals-different-roles-on-a-resource-group-in-a-different-subscription-to-the-one-terraform-is-configured-for)
- [Example - Assign multiple principals different roles on a resource group using the `any_principal` option](#example---assign-multiple-principals-different-roles-on-a-resource-group-using-the-any\\_principal-option)
- [Example - Assign multiple principals to management group, subscription and resource group](#example---assign-multiple-principals-to-management-group-subscription-and-resource-group)
- [Example - Assign a Group account Contributor rights to a single Resource](#example---assign-a-group-account-contributor-rights-to-a-single-resource)
- [Example - Assign a Group account Owner rights to a single Resource in a different subscription to the one Terraform is configured for](#example---assign-a-group-account-owner-rights-to-a-single-resource-in-a-different-subscription-to-the-one-terraform-is-configured-for)
- [Example - Assign a User an Entra ID role](#example---assign-a-user-an-entra-id-role)

### Simple Example - Assign a single User account Owner rights to a single Resource Group

This example shows how to assign a single user principal to a resource group with a built in role definition. The comments in the example re-iterate the generic approach to using this module.

```hcl
module "role_assignments" {
  source = "Azure/avm-ptn-authorization-roleassignment/azurerm"

  # 1 - Define the principal(s)
  users_by_user_principal_name = {
    abc = "abc@def.com"
  }

  # 2 - Define the role definition(s)
  role_definitions = {
    role1 = "Owner"
  }

  # 3 - Map the principal(s) to the role definition(s) at a specific scope(s)
  role_assignments_for_resource_groups = {
    example1 = {
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

> NOTE: Although this may seem like a lot of code for this seemingly simple task, it is important to note that we are referring to our user by their user principal name and we are referring to our role definition by its name. If you were to attempt this same task using the native `azurerm` resources and data sources, you would find that you require at least 3 data sources and 1 resource to achieve the same result.

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

  role_assignments_for_resource_groups = {
    example1 = {
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

### Example - Assign multiple principals different roles on a resource group using the `any_principal` option

This example demonstrates how to use different principal types and different roles to assign multiple principals to a resource group using the `any_principal` option. The `any_principal` variable is a convenience variable that allows you to add all your principals, regardless of type to the same set.

>NOTE: Using the `any_principal` variable requires a unique set of keys for your principals, as the keys are used to create the role assignments. If you have multiple principals with the same key, they will be merged using the following precedence order: `user`, `group`, `app_registration`, `system_assigned_managed_identity`, `user_assigned_managed_identity`.

In this example we are assigning the following roles:

| Role Name | Principal Type | Principal Name |
| --------- | -------------- | -------------- |
| Owner     | User           | <abc@def.com>   |
| Contributor | Group         | my-group       |
| Reader      | App Registration | my-app-registration-1 |
| X Contributor | System Assigned Managed Identity | my-app-service |
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
    mi1 = "my-mi-1" # Note we are using the same key as the system assigned managed identity, this principal will get precedence over the system assigned managed identity. The system assigned managed identity will be ignored.
    mi2 = "my-mi-2"
  }

  role_definitions = {
    owner       = "Owner"
    contributor = "Contributor"
    reader      = "Reader"
  }

  role_assignments_for_resource_groups = {
    example1 = {
      resource_group_name = "rg-example-2"
      subscription_id     = "7d805431-4943-42ed-8116-3b545c2fc459"
      role_assignments = {
        role_assignment_1 = {
          role_definition = "owner"
          any_principals  = ["abc", "mi1", "mi2"]
        }
        role_assignment_2 = {
          role_definition = "contributor"
          any_principals  = ["group1", "mi1"]
        }
        role_assignment_3 = {
          role_definition = "reader"
          any_principals  = ["app1"]
        }
      }
    }
  }
}
```

>NOTE: You can mix and match the `any_principal` variable with the other principal variables. However, if you have a principal in the `any_principal` variable that is also in one of the other principal variables, the apply will fail since it will attempt to create the same role assignment twice.

### Example - Assign multiple principals to management group, subscription and resource group

This example demonstrates how to use different principal types and different roles to assign multiple principals to a management group, subscription and resource group in the same module call. The principal running Terraform would require User Access Administrator rights on the target management group, subscription and resource group.

In this example we are assigning the following roles:

| Role Name | Scope | Principal Type | Principal Name |
| --------- | ----- | -------------- | -------------- |
| Owner     | Management Group: Tenant Root Group | User           | <abc@def.com>   |
| Contributor | Subscription: 7d805431-4943-42ed-8116-3b545c2fc459 | Group         | my-group       |
| Reader      | Resource Group: rg-example-2 | App Registration | my-app-registration-1 |

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

  role_definitions = {
    owner       = "Owner"
    contributor = "Contributor"
    reader      = "Reader"
  }

  role_assignnents_for_management_groups = {
    example1 = {
      management_group_display_name = "Tenant Root Group" # Note that `management_group_display_name` and `management_group_id` are mutually exclusive, supply one or the other.
      role_assignments = {
        role_assignment_1 = {
          role_definition = "owner"
          users           = ["abc"]
        }
      }
    }
  }

  role_assignments_for_subscriptions = {
    example2 = {
      subscription_id = "7d805431-4943-42ed-8116-3b545c2fc459"
      role_assignments = {
        role_assignment_1 = {
          role_definition = "contributor"
          groups          = ["group1"]
        }
      }
    }
  }

  role_assignments_for_resource_groups = {
    example3 = {
      resource_group_name = "rg-example-2"
      subscription_id     = "7d805431-4943-42ed-8116-3b545c2fc459"
      role_assignments = {
        role_assignment_1 = {
          role_definition   = "reader"
          app_registrations = ["app1"]
        }
      }
    }
  }
}
```

### Example - Assign a Group account Contributor rights to a single Resource

In this example we use the convenience variable `role_assignments_for_resources` to find the scope of a resource. You must supply the `resource_name` and `resource_group_name` in order for the module to lookup the scope for you.

>NOTE: This variable only works in the context of the current Terraform subscription, it cannot be used to apply resource scope role assignments in other subscription. If you need to do that, you can use the `role_assignments_for_scopes` variable.

```hcl
module "role_assignments" {
  source = "Azure/avm-ptn-authorization-roleassignment/azurerm"
  groups_by_display_name = {
    group1 = "my-group"
  }
  role_definitions = {
    contributor = "Contributor"
  }
  role_assignments_for_resources = {
    example1 = {
      resource_name       = "my-app-service"
      resource_group_name = "rg-example"
      role_assignments = {
        role_assignment_1 = {
          role_definition = "contributor"
          groups          = ["group1"]
        }
      }
    }
  }
}
```

### Example - Assign a Group account Owner rights to a single Resource in a different subscription to the one Terraform is configured for

In this example we use the convenience variable `role_assignments_for_scopes` to assign a role to an individual resource in a different subscription to the one Terraform is configured for. The principal running Terraform would require User Access Administrator rights on the target resource.

>NOTE: This variable can be used to apply role assignments at any scope, including management group, subscription, resource group and resource.

```hcl
module "role_assignments" {
  source = "Azure/avm-ptn-authorization-roleassignment/azurerm"
  groups_by_display_name = {
    group1 = "my-group"
  }
  role_definitions = {
    owner = "Owner"
  }
  role_assignments_for_scopes = {
    example1 = {
      scope = "subscriptions/7d805431-4943-42ed-8116-3b545c2fc459/resourceGroups/rg-example/providers/Microsoft.Web/sites/my-app-service"
      role_assignments = {
        role_assignment_1 = {
          role_definition = "owner"
          groups          = ["group1"]
        }
      }
    }
  }
}
```

### Example - Assign a User an Entra ID role

In this example we assign a User account a role in Entra ID.

>NOTE: This variable can only be used to apply role assignments in the current tenant.

```hcl
module "role_assignments" {
  source = "Azure/avm-ptn-authorization-roleassignment/azurerm"
  users_by_user_principal_name = {
    abc = "abc@def.com"
  }
  entra_id_role_definitions = {
    application-administrator = "Application Administrator"
  }
  role_assignments_for_entra_id = {
    example1 = {
      role_assignments = {
        role_assignment_1 = {
          role_definition = "application-administrator"
          groups          = ["abc"]
        }
      }
    }
  }
}
```

<!-- markdownlint-disable MD033 -->
## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (~> 1.6)

- <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) (~> 2.46)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (~> 3.71)

- <a name="requirement_random"></a> [random](#requirement\_random) (~> 3.5)

## Providers

The following providers are used by this module:

- <a name="provider_azuread"></a> [azuread](#provider\_azuread) (~> 2.46)

- <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) (~> 3.71)

- <a name="provider_random"></a> [random](#provider\_random) (~> 3.5)

## Resources

The following resources are used by this module:

- [azuread_directory_role.entra_id_role_definitions_by_name](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/directory_role) (resource)
- [azuread_directory_role_assignment.this](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/directory_role_assignment) (resource)
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
- [azurerm_management_group.management_groups_by_id_or_display_name](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/management_group) (data source)
- [azurerm_resources.resources_by_resource_group_and_name](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/resources) (data source)
- [azurerm_role_definition.role_definitions_by_name](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/role_definition) (data source)
- [azurerm_user_assigned_identity.user_assigned_managed_identities_by_resource_group_and_name](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/user_assigned_identity) (data source)

<!-- markdownlint-disable MD013 -->
## Required Inputs

No required inputs.

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_app_registrations_by_client_id"></a> [app\_registrations\_by\_client\_id](#input\_app\_registrations\_by\_client\_id)

Description: (Optional) A map of Entra ID application registrations to reference in role assignments.  
The key is something unique to you. The value is the client ID (application ID) of the application registration.

Example Input:

```hcl
app_registrations_by_client_id = {
  my-app-1 = "00000000-0000-0000-0000-000000000001"
  my-app-2 = "00000000-0000-0000-0000-000000000002"
}
```

Type: `map(string)`

Default: `{}`

### <a name="input_app_registrations_by_display_name"></a> [app\_registrations\_by\_display\_name](#input\_app\_registrations\_by\_display\_name)

Description: (Optional) A map of Entra ID application registrations to reference in role assignments.  
The key is something unique to you. The value is the display name of the application registration.

Example Input:

```hcl
app_registrations_by_display_name = {
  my-app-1 = "My App 1"
  my-app-2 = "My App 2"
}
```

Type: `map(string)`

Default: `{}`

### <a name="input_app_registrations_by_object_id"></a> [app\_registrations\_by\_object\_id](#input\_app\_registrations\_by\_object\_id)

Description: (Optional) A map of Entra ID application registrations to reference in role assignments.  
The key is something unique to you. The value is the object ID of the application registration.

Example Input:

```hcl
app_registrations_by_object_id = {
  my-app-1 = "00000000-0000-0000-0000-000000000001"
  my-app-2 = "00000000-0000-0000-0000-000000000002"
}
```

Type: `map(string)`

Default: `{}`

### <a name="input_app_registrations_by_principal_id"></a> [app\_registrations\_by\_principal\_id](#input\_app\_registrations\_by\_principal\_id)

Description: (Optional) A map of Entra ID application registrations to reference in role assignments.  
The key is something unique to you. The value is the principal ID of the service principal backing the application registration.

Example Input:

```hcl
app_registrations_by_principal_id = {
  my-app-1 = "00000000-0000-0000-0000-000000000001"
  my-app-2 = "00000000-0000-0000-0000-000000000002"
}
```

Type: `map(string)`

Default: `{}`

### <a name="input_enable_telemetry"></a> [enable\_telemetry](#input\_enable\_telemetry)

Description: This variable controls whether or not telemetry is enabled for the module.  
For more information see https://aka.ms/avm/telemetryinfo.  
If it is set to false, then no telemetry will be collected.

Type: `bool`

Default: `true`

### <a name="input_entra_id_role_definitions"></a> [entra\_id\_role\_definitions](#input\_entra\_id\_role\_definitions)

Description: (Optional) A map of Entra ID role definitions to reference in role assignments.  
The key is something unique to you. The value is a built in or custom role definition name.

Example Input:

```hcl
entra_id_role_definitions = {
  directory-writer     = "Directory Writer"
  global-administrator = "Global Administrator"
}
```

Type: `map(string)`

Default: `{}`

### <a name="input_groups_by_display_name"></a> [groups\_by\_display\_name](#input\_groups\_by\_display\_name)

Description: (Optional) A map of Entra ID groups to reference in role assignments.  
The key is something unique to you. The value is the display name of the group.

Example Input:

```hcl
groups_by_display_name = {
  my-group-1 = "My Group 1"
  my-group-2 = "My Group 2"
}
```

Type: `map(string)`

Default: `{}`

### <a name="input_groups_by_mail_nickname"></a> [groups\_by\_mail\_nickname](#input\_groups\_by\_mail\_nickname)

Description: (Optional) A map of Entra ID groups to reference in role assignments.  
The key is something unique to you. The value is the mail nickname of the group.

Example Input:

```hcl
groups_by_mail_nickname = {
  my-group-1 = "my-group-1-nickname"
  my-group-2 = "my-group-2-nickname"
}
```

Type: `map(string)`

Default: `{}`

### <a name="input_groups_by_object_id"></a> [groups\_by\_object\_id](#input\_groups\_by\_object\_id)

Description: (Optional) A map of Entra ID groups to reference in role assignments.  
The key is something unique to you. The value is the object ID of the group.

Example Input:

```hcl
groups_by_object_id = {
  my-group-1 = "00000000-0000-0000-0000-000000000001"
  my-group-2 = "00000000-0000-0000-0000-000000000002"
}
```

Type: `map(string)`

Default: `{}`

### <a name="input_role_assignments_for_entra_id"></a> [role\_assignments\_for\_entra\_id](#input\_role\_assignments\_for\_entra\_id)

Description: (Optional) Role assignments to be applied to Entra ID.  
This variable allows the assignment of Entra ID directory roles outside of the scope of Azure Resource Manager.  
This variable requires the `entra_id_role_definitions` variable to be populated.

- role\_assignments: (Required) The role assignments to be applied to the scope.
  - role\_definition: (Required) The key of the role definition as defined in the `entra_id_role_definitions` variable.
  - users: (Optional) The keys of the users as defined in one of the `users_by_...` variables.
  - groups: (Optional) The keys of the groups as defined in one of the `groups_by_...` variables.
  - app\_registrations: (Optional) The keys of the app registrations as defined in one of the `app_registrations_by_...` variables.
  - system\_assigned\_managed\_identities: (Optional) The keys of the system assigned managed identities as defined in one of the `system_assigned_managed_identities_by_...` variables.
  - user\_assigned\_managed\_identities: (Optional) The keys of the user assigned managed identities as defined in one of the `user_assigned_managed_identities_by_...` variables.
  - any\_principals: (Optional) The keys of the principals as defined in any of the `[principal_type]_by_...` variables. This is a convenience method that can be used in combination with or instrad of the specific principal type options.

Example Input:

```hcl
role_assignments_for_entra_id = {
  role_assignments    = {
    role_definition = "directory-writer"
    users = [
      "my-user-1",
      "my-user-2"
    ]
    groups = [
      "my-group-1",
      "my-group-2"
    ]
    app_registrations = [
      "my-app-1",
      "my-app-2"
    ]
    system_assigned_managed_identities = [
      "my-vm-1",
      "my-vm-2"
    ]
    user_assigned_managed_identities = [
      "my-user-assigned-managed-identity-1",
      "my-user-assigned-managed-identity-2"
    ]
  }
}
```

Type:

```hcl
map(object({
    role_assignments = map(object({
      role_definition                    = string
      users                              = optional(set(string), [])
      groups                             = optional(set(string), [])
      app_registrations                  = optional(set(string), [])
      system_assigned_managed_identities = optional(set(string), [])
      user_assigned_managed_identities   = optional(set(string), [])
      any_principals                     = optional(set(string), [])
    }))
  }))
```

Default: `{}`

### <a name="input_role_assignments_for_management_groups"></a> [role\_assignments\_for\_management\_groups](#input\_role\_assignments\_for\_management\_groups)

Description: (Optional) Role assignments to be applied to management groups.  
This is a convenience variable that avoids the need to find the resource id of the management group.

- management\_group\_id: (Optional) The id of the management group (one of `management_group_id` or `management_group_display_name` must be supplied).
- management\_group\_display\_name: (Optional) The display name of the management group.
- role\_assignments: (Required) The role assignments to be applied to the scope.
  - role\_definition: (Required) The key of the role definition as defined in the `role_definitions` variable.
  - users: (Optional) The keys of the users as defined in one of the `users_by_...` variables.
  - groups: (Optional) The keys of the groups as defined in one of the `groups_by_...` variables.
  - app\_registrations: (Optional) The keys of the app registrations as defined in one of the `app_registrations_by_...` variables.
  - system\_assigned\_managed\_identities: (Optional) The keys of the system assigned managed identities as defined in one of the `system_assigned_managed_identities_by_...` variables.
  - user\_assigned\_managed\_identities: (Optional) The keys of the user assigned managed identities as defined in one of the `user_assigned_managed_identities_by_...` variables.
  - any\_principals: (Optional) The keys of the principals as defined in any of the `[principal_type]_by_...` variables. This is a convenience method that can be used in combination with or instrad of the specific principal type options.

Example Input:

```hcl
role_assignments_for_management_groups = {
  management_group_id = "mg-1-id"
  role_assignments    = {
    role_definition = "contributor"
    users = [
      "my-user-1",
      "my-user-2"
    ]
    groups = [
      "my-group-1",
      "my-group-2"
    ]
    app_registrations = [
      "my-app-1",
      "my-app-2"
    ]
    system_assigned_managed_identities = [
      "my-vm-1",
      "my-vm-2"
    ]
    user_assigned_managed_identities = [
      "my-user-assigned-managed-identity-1",
      "my-user-assigned-managed-identity-2"
    ]
  }
}

role_assignments_for_management_groups = {
  management_group_display_name = "mg-1-display-name"
  role_assignments              = {
    role_definition = "contributor"
    users = [
      "my-user-1",
      "my-user-2"
    ]
    groups = [
      "my-group-1",
      "my-group-2"
    ]
    app_registrations = [
      "my-app-1",
      "my-app-2"
    ]
    system_assigned_managed_identities = [
      "my-vm-1",
      "my-vm-2"
    ]
    user_assigned_managed_identities = [
      "my-user-assigned-managed-identity-1",
      "my-user-assigned-managed-identity-2"
    ]
  }
}
```

Type:

```hcl
map(object({
    management_group_id           = optional(string, null)
    management_group_display_name = optional(string, null)
    role_assignments = map(object({
      role_definition                    = string
      users                              = optional(set(string), [])
      groups                             = optional(set(string), [])
      app_registrations                  = optional(set(string), [])
      system_assigned_managed_identities = optional(set(string), [])
      user_assigned_managed_identities   = optional(set(string), [])
      any_principals                     = optional(set(string), [])
    }))
  }))
```

Default: `{}`

### <a name="input_role_assignments_for_resource_groups"></a> [role\_assignments\_for\_resource\_groups](#input\_role\_assignments\_for\_resource\_groups)

Description: (Optional) Role assignments to be applied to resource groups.  
The resource group can be in the current subscription (default) or a `subscription_id` can be supplied to target a resource group in another subscription.  
This is a convenience variable that avoids the need to find the resource id of the resource group.

- resource\_group\_name: (Required) The name of the resource group.
- subscription\_id: (Optional) The id of the subscription. If not supplied the current subscription is used.
- role\_assignments: (Required) The role assignments to be applied to the scope.
  - role\_definition: (Required) The key of the role definition as defined in the `role_definitions` variable.
  - users: (Optional) The keys of the users as defined in one of the `users_by_...` variables.
  - groups: (Optional) The keys of the groups as defined in one of the `groups_by_...` variables.
  - app\_registrations: (Optional) The keys of the app registrations as defined in one of the `app_registrations_by_...` variables.
  - system\_assigned\_managed\_identities: (Optional) The keys of the system assigned managed identities as defined in one of the `system_assigned_managed_identities_by_...` variables.
  - user\_assigned\_managed\_identities: (Optional) The keys of the user assigned managed identities as defined in one of the `user_assigned_managed_identities_by_...` variables.
  - any\_principals: (Optional) The keys of the principals as defined in any of the `[principal_type]_by_...` variables. This is a convenience method that can be used in combination with or instrad of the specific principal type options.

Example Input:

```hcl
role_assignments_for_resource_groups = {
  resource_group_name = "my-resource-group-name"
  role_assignments    = {
    role_definition = "contributor"
    users = [
      "my-user-1",
      "my-user-2"
    ]
    groups = [
      "my-group-1",
      "my-group-2"
    ]
    app_registrations = [
      "my-app-1",
      "my-app-2"
    ]
    system_assigned_managed_identities = [
      "my-vm-1",
      "my-vm-2"
    ]
    user_assigned_managed_identities = [
      "my-user-assigned-managed-identity-1",
      "my-user-assigned-managed-identity-2"
    ]
  }
}
```

Type:

```hcl
map(object({
    resource_group_name = string
    subscription_id     = optional(string, null)
    role_assignments = map(object({
      role_definition                    = string
      users                              = optional(set(string), [])
      groups                             = optional(set(string), [])
      app_registrations                  = optional(set(string), [])
      system_assigned_managed_identities = optional(set(string), [])
      user_assigned_managed_identities   = optional(set(string), [])
      any_principals                     = optional(set(string), [])
    }))
  }))
```

Default: `{}`

### <a name="input_role_assignments_for_resources"></a> [role\_assignments\_for\_resources](#input\_role\_assignments\_for\_resources)

Description: (Optional) Role assignments to be applied to resources. The resource is defined by the resource name and the resource group name.  
This variable only works with the current provider subscription. This is a convenience variable that avoids the need to find the resource id.

- resouce\_name: (Required) The names of the resource.
- resource\_group\_name: (Required) The name of the resource group.
- role\_assignments: (Required) The role assignments to be applied to the scope.
  - role\_definition: (Required) The key of the role definition as defined in the `role_definitions` variable.
  - users: (Optional) The keys of the users as defined in one of the `users_by_...` variables.
  - groups: (Optional) The keys of the groups as defined in one of the `groups_by_...` variables.
  - app\_registrations: (Optional) The keys of the app registrations as defined in one of the `app_registrations_by_...` variables.
  - system\_assigned\_managed\_identities: (Optional) The keys of the system assigned managed identities as defined in one of the `system_assigned_managed_identities_by_...` variables.
  - user\_assigned\_managed\_identities: (Optional) The keys of the user assigned managed identities as defined in one of the `user_assigned_managed_identities_by_...` variables.
  - any\_principals: (Optional) The keys of the principals as defined in any of the `[principal_type]_by_...` variables. This is a convenience method that can be used in combination with or instrad of the specific principal type options.

Example Input:

```hcl
role_assignments_for_resources = {
  resource_name       = "my-resource-name"
  resource_group_name = "my-resource-group-name"
  role_assignments    = {
    role_definition = "contributor"
    users = [
      "my-user-1",
      "my-user-2"
    ]
    groups = [
      "my-group-1",
      "my-group-2"
    ]
    app_registrations = [
      "my-app-1",
      "my-app-2"
    ]
    system_assigned_managed_identities = [
      "my-vm-1",
      "my-vm-2"
    ]
    user_assigned_managed_identities = [
      "my-user-assigned-managed-identity-1",
      "my-user-assigned-managed-identity-2"
    ]
  }
}
```

Type:

```hcl
map(object({
    resource_name       = string
    resource_group_name = string
    role_assignments = map(object({
      role_definition                    = string
      users                              = optional(set(string), [])
      groups                             = optional(set(string), [])
      app_registrations                  = optional(set(string), [])
      system_assigned_managed_identities = optional(set(string), [])
      user_assigned_managed_identities   = optional(set(string), [])
      any_principals                     = optional(set(string), [])
    }))
  }))
```

Default: `{}`

### <a name="input_role_assignments_for_scopes"></a> [role\_assignments\_for\_scopes](#input\_role\_assignments\_for\_scopes)

Description: (Optional) Role assignments to be applied to specific scope ids. The scope id is the id of the resource, resource group, subscription or management group.

- scope: (Required) The scope / id of the resource, resource group, subscription or management group.
- role\_assignments: (Required) The role assignments to be applied to the scope.
  - role\_definition: (Required) The key of the role definition as defined in the `role_definitions` variable.
  - users: (Optional) The keys of the users as defined in one of the `users_by_...` variables.
  - groups: (Optional) The keys of the groups as defined in one of the `groups_by_...` variables.
  - app\_registrations: (Optional) The keys of the app registrations as defined in one of the `app_registrations_by_...` variables.
  - system\_assigned\_managed\_identities: (Optional) The keys of the system assigned managed identities as defined in one of the `system_assigned_managed_identities_by_...` variables.
  - user\_assigned\_managed\_identities: (Optional) The keys of the user assigned managed identities as defined in one of the `user_assigned_managed_identities_by_...` variables.
  - any\_principals: (Optional) The keys of the principals as defined in any of the `[principal_type]_by_...` variables. This is a convenience method that can be used in combination with or instrad of the specific principal type options.

Example Input:

```hcl
role_assignments_for_scopes = {
  scope            = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/my-resource-group"
  role_assignments = {
    role_definition = "contributor"
    users = [
      "my-user-1",
      "my-user-2"
    ]
    groups = [
      "my-group-1",
      "my-group-2"
    ]
    app_registrations = [
      "my-app-1",
      "my-app-2"
    ]
    system_assigned_managed_identities = [
      "my-vm-1",
      "my-vm-2"
    ]
    user_assigned_managed_identities = [
      "my-user-assigned-managed-identity-1",
      "my-user-assigned-managed-identity-2"
    ]
  }
}
```

Type:

```hcl
map(object({
    scope = string
    role_assignments = map(object({
      role_definition                    = string
      users                              = optional(set(string), [])
      groups                             = optional(set(string), [])
      app_registrations                  = optional(set(string), [])
      system_assigned_managed_identities = optional(set(string), [])
      user_assigned_managed_identities   = optional(set(string), [])
      any_principals                     = optional(set(string), [])
    }))
  }))
```

Default: `{}`

### <a name="input_role_assignments_for_subscriptions"></a> [role\_assignments\_for\_subscriptions](#input\_role\_assignments\_for\_subscriptions)

Description: (Optional) Role assignments to be applied to subscriptions.  
This will default to the current subscription (default) or a `subscription_id` can be supplied to target another subscription.  
This is a convenience variable that avoids the need to find the resource id of the subscription.

- subscription\_id: (Optional) The id of the subscription. If not supplied the current subscription is used.
- role\_assignments: (Required) The role assignments to be applied to the scope.
  - role\_definition: (Required) The key of the role definition as defined in the `role_definitions` variable.
  - users: (Optional) The keys of the users as defined in one of the `users_by_...` variables.
  - groups: (Optional) The keys of the groups as defined in one of the `groups_by_...` variables.
  - app\_registrations: (Optional) The keys of the app registrations as defined in one of the `app_registrations_by_...` variables.
  - system\_assigned\_managed\_identities: (Optional) The keys of the system assigned managed identities as defined in one of the `system_assigned_managed_identities_by_...` variables.
  - user\_assigned\_managed\_identities: (Optional) The keys of the user assigned managed identities as defined in one of the `user_assigned_managed_identities_by_...` variables.
  - any\_principals: (Optional) The keys of the principals as defined in any of the `[principal_type]_by_...` variables. This is a convenience method that can be used in combination with or instrad of the specific principal type options.

Example Input:

```hcl
role_assignments_for_subscriptions = {
  subscription_id     = "00000000-0000-0000-0000-000000000000"
  role_assignments    = {
    role_definition = "contributor"
    users = [
      "my-user-1",
      "my-user-2"
    ]
    groups = [
      "my-group-1",
      "my-group-2"
    ]
    app_registrations = [
      "my-app-1",
      "my-app-2"
    ]
    system_assigned_managed_identities = [
      "my-vm-1",
      "my-vm-2"
    ]
    user_assigned_managed_identities = [
      "my-user-assigned-managed-identity-1",
      "my-user-assigned-managed-identity-2"
    ]
  }
}
```

Type:

```hcl
map(object({
    subscription_id = optional(string, null)
    role_assignments = map(object({
      role_definition                    = string
      users                              = optional(set(string), [])
      groups                             = optional(set(string), [])
      app_registrations                  = optional(set(string), [])
      system_assigned_managed_identities = optional(set(string), [])
      user_assigned_managed_identities   = optional(set(string), [])
      any_principals                     = optional(set(string), [])
    }))
  }))
```

Default: `{}`

### <a name="input_role_definitions"></a> [role\_definitions](#input\_role\_definitions)

Description: (Optional) A map of Azure Resource Manager role definitions to reference in role assignments.  
The key is something unique to you. The value is a built in or custom role definition name.

Example Input:

```hcl
role_definitions = {
  owner       = "Owner"
  contributor = "Contributor"
  reader      = "Reader"
}
```

Type: `map(string)`

Default: `{}`

### <a name="input_system_assigned_managed_identities_by_client_id"></a> [system\_assigned\_managed\_identities\_by\_client\_id](#input\_system\_assigned\_managed\_identities\_by\_client\_id)

Description: (Optional) A map of system assigned managed identities to reference in role assignments.  
The key is something unique to you. The value is the client id of the identity.

Example Input:

```hcl
system_assigned_managed_identities_by_client_id = {
  my-vm-1 = "00000000-0000-0000-0000-000000000001"
  my-vm-2 = "00000000-0000-0000-0000-000000000002"
}
```

Type: `map(string)`

Default: `{}`

### <a name="input_system_assigned_managed_identities_by_display_name"></a> [system\_assigned\_managed\_identities\_by\_display\_name](#input\_system\_assigned\_managed\_identities\_by\_display\_name)

Description: (Optional) A map of system assigned managed identities to reference in role assignments.  
The key is something unique to you. The value is the display name of the identity / compute instance.

Example Input:

```hcl
system_assigned_managed_identities_by_display_name = {
  my-vm-1 = "My VM 1"
  my-vm-2 = "My VM 2"
}
```

Type: `map(string)`

Default: `{}`

### <a name="input_system_assigned_managed_identities_by_principal_id"></a> [system\_assigned\_managed\_identities\_by\_principal\_id](#input\_system\_assigned\_managed\_identities\_by\_principal\_id)

Description: (Optional) A map of system assigned managed identities to reference in role assignments.  
The key is something unique to you. The value is the principal id of the underying service principalk of the identity.

Example Input:

```hcl
system_assigned_managed_identities_by_principal_id = {
  my-vm-1 = "00000000-0000-0000-0000-000000000001"
  my-vm-2 = "00000000-0000-0000-0000-000000000002"
}
```

Type: `map(string)`

Default: `{}`

### <a name="input_telemetry_resource_group_name"></a> [telemetry\_resource\_group\_name](#input\_telemetry\_resource\_group\_name)

Description: The resource group where the telemetry will be deployed.

Type: `string`

Default: `""`

### <a name="input_user_assigned_managed_identities_by_client_id"></a> [user\_assigned\_managed\_identities\_by\_client\_id](#input\_user\_assigned\_managed\_identities\_by\_client\_id)

Description: (Optional) A map of system assigned managed identities to reference in role assignments.  
The key is something unique to you. The value is the client id of the identity.

Example Input:

```hcl
user_assigned_managed_identities_by_client_id = {
  my-identity-1 = "00000000-0000-0000-0000-000000000001"
  my-identity-2 = "00000000-0000-0000-0000-000000000002"
}
```

Type: `map(string)`

Default: `{}`

### <a name="input_user_assigned_managed_identities_by_display_name"></a> [user\_assigned\_managed\_identities\_by\_display\_name](#input\_user\_assigned\_managed\_identities\_by\_display\_name)

Description: (Optional) A map of system assigned managed identities to reference in role assignments.  
The key is something unique to you. The value is the display name of the identity.

Example Input:

```hcl
user_assigned_managed_identities_by_display_name = {
  my-identity-1 = "My Identity 1"
  my-identity-2 = "My Identity 2"
}
```

Type: `map(string)`

Default: `{}`

### <a name="input_user_assigned_managed_identities_by_principal_id"></a> [user\_assigned\_managed\_identities\_by\_principal\_id](#input\_user\_assigned\_managed\_identities\_by\_principal\_id)

Description: (Optional) A map of system assigned managed identities to reference in role assignments.  
The key is something unique to you. The value is the principal id of the underying service principalk of the identity.

Example Input:

```hcl
user_assigned_managed_identities_by_principal_id = {
  my-identity-1 = "00000000-0000-0000-0000-000000000001"
  my-identity-2 = "00000000-0000-0000-0000-000000000002"
}
```

Type: `map(string)`

Default: `{}`

### <a name="input_user_assigned_managed_identities_by_resource_group_and_name"></a> [user\_assigned\_managed\_identities\_by\_resource\_group\_and\_name](#input\_user\_assigned\_managed\_identities\_by\_resource\_group\_and\_name)

Description: (Optional) A map of user assigned managed identities to reference in role assignments.  
The key is something unique to you. The values are:

- resource\_group\_name: The name of the resource group the identity is in.
- name: The name of the identity.

Example Input:

```hcl
user_assigned_managed_identities_by_resource_group_and_name = {
  my-identity-1 = {
    resource_group_name = "my-rg-1"
    name                = "my-identity-1"
  }
  my-identity-2 = {
    resource_group_name = "my-rg-2"
    name                = "my-identity-2"
  }
}
```

Type:

```hcl
map(object({
    resource_group_name = string
    name                = string
  }))
```

Default: `{}`

### <a name="input_users_by_employee_id"></a> [users\_by\_employee\_id](#input\_users\_by\_employee\_id)

Description: (Optional) A map of Entra ID users to reference in role assignments.  
The key is something unique to you. The value is the employee ID of the user.

Example Input:

```hcl
users_by_employee_id = {
  my-user-1 = "1234567890"
  my-user-2 = "0987654321"
}
```

Type: `map(string)`

Default: `{}`

### <a name="input_users_by_mail"></a> [users\_by\_mail](#input\_users\_by\_mail)

Description: (Optional) A map of Entra ID users to reference in role assignments.  
The key is something unique to you. The value is the mail address of the user.

Example Input:

```hcl
users_by_mail = {
  my-user-1 = "user.1@example.com"
  my-user-2 = "user.2@example.com"
}
```

Type: `map(string)`

Default: `{}`

### <a name="input_users_by_mail_nickname"></a> [users\_by\_mail\_nickname](#input\_users\_by\_mail\_nickname)

Description: (Optional) A map of Entra ID users to reference in role assignments.  
The key is something unique to you. The value is the mail nickname of the user.

Example Input:

```hcl
users_by_mail_nickname = {
  my-user-1 = "user1-nickname"
  my-user-2 = "user2-nickname"
}
```

Type: `map(string)`

Default: `{}`

### <a name="input_users_by_object_id"></a> [users\_by\_object\_id](#input\_users\_by\_object\_id)

Description: (Optional) A map of Entra ID users to reference in role assignments.  
The key is something unique to you. The value is the object ID of the user.

Example Input:

```hcl
users_by_object_id = {
  my-user-1 = "00000000-0000-0000-0000-000000000001"
  my-user-2 = "00000000-0000-0000-0000-000000000002"
}
```

Type: `map(string)`

Default: `{}`

### <a name="input_users_by_user_principal_name"></a> [users\_by\_user\_principal\_name](#input\_users\_by\_user\_principal\_name)

Description: (Optional) A map of Entra ID users to reference in role assignments.  
The key is something unique to you. The value is the user principal name (UPN) of the user.

Example Input:

```hcl
users_by_user_principal_name = {
  my-user-1 = "user1@example.com"
  my-user-2 = "user2@example.com"
}
```

Type: `map(string)`

Default: `{}`

## Outputs

The following outputs are exported:

### <a name="output_all_principals"></a> [all\_principals](#output\_all\_principals)

Description: A map of all principals. The key is the key you supplied and the value is the principal id (object id) of the user, group, service principal, or managed identity.

### <a name="output_app_registrations"></a> [app\_registrations](#output\_app\_registrations)

Description: A map of Entra ID application registrations. The key is the key you supplied and the value is the principal id (object id) of the service principal backing the application registration.

### <a name="output_entra_id_role_assignments"></a> [entra\_id\_role\_assignments](#output\_entra\_id\_role\_assignments)

Description: A map of Entra ID role assignments. The key is the key you supplied and the value is the role assignment details:

- role\_definition\_id: The role definition template id of the role assignment.
- principal\_id: The principal id (object id) of the user, group, service principal, or managed identity the role assignment is for.

### <a name="output_entra_id_role_definitions"></a> [entra\_id\_role\_definitions](#output\_entra\_id\_role\_definitions)

Description: A map of Entra ID role definitions. The key is the key you supplied and the value is the role definition template id.

### <a name="output_groups"></a> [groups](#output\_groups)

Description: A map of Entra ID groups. The key is the key you supplied and the value is the principal id (object id) of the group.

### <a name="output_role_assignments"></a> [role\_assignments](#output\_role\_assignments)

Description: A map of Azure Resource Manager role assignments. The key is the key you supplied and the value is the role assignment details:

- role\_definition\_id: The role definition id of the role assignment.
- principal\_id: The principal id (object id) of the user, group, service principal, or managed identity the role assignment is for.
- scope: The scope of the role assignment.

### <a name="output_role_defintions"></a> [role\_defintions](#output\_role\_defintions)

Description: A map of Azure Resource Manager role definitions. The key is the key you supplied and the value consists of is the role definition id and the allowed scopes.

### <a name="output_system_assigned_managed_identities"></a> [system\_assigned\_managed\_identities](#output\_system\_assigned\_managed\_identities)

Description: A map of system assigned managed identities. The key is the key you supplied and value is the principal id (object id) of the service principal backing system assigned managed identity.

### <a name="output_user_assigned_managed_identities"></a> [user\_assigned\_managed\_identities](#output\_user\_assigned\_managed\_identities)

Description: A map of user assigned managed identities. The key is the key you supplied and value is the principal id (object id) of the service principal backing user assigned managed identity.

### <a name="output_users"></a> [users](#output\_users)

Description: A map of Entra ID users. The key is the key you supplied and the value is the principal id (object id) of the user.

## Modules

No modules.

<!-- markdownlint-disable-next-line MD041 -->
## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the repository. There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
<!-- END_TF_DOCS -->