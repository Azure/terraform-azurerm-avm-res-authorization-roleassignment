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
    user1 = "abc@def.com"
  }
  role_definitions = {
    role1 = "Owner"
  }
  role_assignments_by_resource_group = {
    role_assignment1 = {
      resource_group_name = "rg-example"
      role_assignments = {
        role_definition = "role1"
        users           = ["user1"]
      }
    }
  }
}
```

> NOTE: Although this may seem like a lot of code for this seemingly simple task, it is important to note that we are referring to our User principal by it's User Principal Name and we are referring to out Role Definition by it's name. If you were to attempt this same task using the built in `azurerm` resources and data sources, you would find that you require at least 3 data sources and 1 resource to achieve the same result.
