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

### Example - Assign multiple principals different roles on a resource group using the `any_principal` option

This example demonstrates how to use different principal types and different roles to assign multiple principals to a resource group using the `any_principal` option. The `any_principal` variable is a convenience variable that allows you to add all your principals, regardless of type to the same set.

>NOTE: Using the `any_principal` variable requires a unique set of keys for your principals, as the keys are used to create the role assignments. If you have multiple principals with the same key, they will be merged using the following precedence order: `user`, `group`, `app_registration`, `system_assigned_managed_identity`, `user_assigned_managed_identity`.

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
    mi1 = "my-mi-1" # Note we are using the same key as the system assigned managed identity, this principal will get precedence over the system assigned managed identity. The system assigned managed identity will be ignored.
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
          role_definition = "owner"
          any_principals  = ["abc","mi1", "mi2"]
        }
        role_assignment_2 = {
          role_definition = "contributor"
          any_principals  = ["group1","mi1"]
        }
        role_assignment_3 = {
          role_definition   = "reader"
          any_principals = ["app1"]
        }
      }
    }
  }
}
```

>NOTE: You can mix and match the `any_principal` variable with the other principal variables. However, if you have a principal in the `any_principal` variable that is also in one of the other principal variables, the apply will fail since it will attempt to create the same role assignment twice.
