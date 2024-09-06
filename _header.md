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

The module provides 2 ways to create role assignments:

1. Basic: This just uses the `role_assignments` and `role_assignments_entra_id` variable to create role assignments and you need to supply the principal id, scope and role definition data yourself.
1. Advanced: This uses a set of variables to define the principals, role definitions and role assignments separately and then map them together to create the role assignments.

### Basic Usage

The basic usage is a simple way to create role assignments. You must supply the principal id, scope and role definition data yourself.

Here is an example to apply the Owner role to a user principal at the subscription scope:

```hcl
module "role_assignments" {
  source = "Azure/avm-ptn-authorization-roleassignment/azurerm"

  role_assignments = {
    user1_owner = {
      principal_id         = "00000000-0000-0000-0000-000000000000"
      role_definition_name = "Owner"
      scope                = "/subscriptions/00000000-0000-0000-0000-000000000000"
    }
  }
}
```

Here is an example to apply the Directory Reader role to a user principal at the Entra ID scope:

```hcl
module "role_assignments_for_entra_id" {
  source = "Azure/avm-ptn-authorization-roleassignment/azurerm"

  role_assignments_entra_id = {
    user1_directory_reader = {
      principal_object_id = "00000000-0000-0000-0000-000000000000"
      role_id             = "00000000-0000-0000-0000-000000000000"
    }
  }
}
```

### Advanced Usage

The module takes a mapping approach for advanced usage, where you define the principals and role definitions with keys, then map them together to define role assignments. This approach enables you to create role assignments at multiple scopes for multiple principals with multiple methods of finding the principal id.

#### Approach

The following steps outline the approach to using this module:

1. Define the principals
2. Define the role definitions
3. Map the principals to the role definitions at a specific scope

##### 1 - Define the principals

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

##### 2 - Define the role definitions

You can use either built in or custom role definitions. There are two variables used to find role definitions:

- `role_definitions`: Find Azure Resource Manager role definitions by their name.
- `entra_id_role_definitions`: Find Entra ID role definitions by their name.

##### 3 - Map the principals to the role definitions at a specific scope

There are several variables that can be used to map the principals to the role definitions at a specific scope:

- `role_assignments_for_entra_id`: Map principals to role definitions in Entra ID. This only works in the context of the current tenant.
- `role_assignments_for_management_groups`: Map principals to role definitions at the management group scope.
- `role_assignments_for_subscriptions`: Map principals to role definitions at the subscription scope. This works cross-subscription.
- `role_assignments_for_resource_groups`: Map principals to role definitions at the resource group scope. This works cross-subscription.
- `role_assignments_for_resources`: Map principals to role definitions at the resource scope. This only works in the scope of the current subscription.
- `role_assignments_for_scopes`: Map principals to role definitions at any scope. This is a catch all and you must supply the scope / resource id. This works cross-subscription.

### Examples

The following examples show common usage patterns:

- [Simple Example - Assign a single User account Owner rights to a single Resource Group](#simple-example---assign-a-single-user-account-owner-rights-to-a-single-resource-group)
- [Example - Assign multiple principals different roles on a resource group in a different subscription to the one Terraform is configured for](#example---assign-multiple-principals-different-roles-on-a-resource-group-in-a-different-subscription-to-the-one-terraform-is-configured-for)
- [Example - Assign multiple principals different roles on a resource group using the `any_principal` option](#example---assign-multiple-principals-different-roles-on-a-resource-group-using-the-any\_principal-option)
- [Example - Assign multiple principals to management group, subscription and resource group](#example---assign-multiple-principals-to-management-group-subscription-and-resource-group)
- [Example - Assign a Group account Contributor rights to a single Resource](#example---assign-a-group-account-contributor-rights-to-a-single-resource)
- [Example - Assign a Group account Owner rights to a single Resource in a different subscription to the one Terraform is configured for](#example---assign-a-group-account-owner-rights-to-a-single-resource-in-a-different-subscription-to-the-one-terraform-is-configured-for)
- [Example - Assign a User an Entra ID role](#example---assign-a-user-an-entra-id-role)

#### Simple Example - Assign a single User account Owner rights to a single Resource Group

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

#### Example - Assign multiple principals different roles on a resource group in a different subscription to the one Terraform is configured for

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

#### Example - Assign multiple principals different roles on a resource group using the `any_principal` option

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

#### Example - Assign multiple principals to management group, subscription and resource group

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

#### Example - Assign a Group account Contributor rights to a single Resource

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

#### Example - Assign a Group account Owner rights to a single Resource in a different subscription to the one Terraform is configured for

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

#### Example - Assign a User an Entra ID role

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
