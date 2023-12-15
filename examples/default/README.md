<!-- BEGIN_TF_DOCS -->
# Default example

This deploys the module in its simplest form.

```hcl
module "avm-ptn-authorization-roleassignment" {
  source = "../../"
  # source = "Azure/avm-ptn-authorization-roleassignment/azurerm"
  enable_telemetry = var.enable_telemetry

  depends_on = [azuread_service_principal.test, azuread_user.test, azuread_group.test, azuread_application.test, azurerm_static_site.test, azurerm_user_assigned_identity.test, data.azuread_service_principal.test]

  users_by_user_principal_name = {
    (local.users.user1) = azuread_user.test[local.users.user1].user_principal_name
    (local.users.user2) = azuread_user.test[local.users.user2].user_principal_name
  }
  users_by_mail = {
    (local.users.user1) = azuread_user.test[local.users.user1].mail
    (local.users.user3) = azuread_user.test[local.users.user3].mail
  }
  users_by_mail_nickname = {
    (local.users.user1) = azuread_user.test[local.users.user1].mail_nickname
    (local.users.user4) = azuread_user.test[local.users.user4].mail_nickname
  }
  users_by_employee_id = {
    (local.users.user1) = azuread_user.test[local.users.user1].employee_id
    (local.users.user5) = azuread_user.test[local.users.user5].employee_id
  }
  users_by_object_id = {
    (local.users.user1) = azuread_user.test[local.users.user1].object_id
    (local.users.user6) = azuread_user.test[local.users.user6].object_id
  }

  groups_by_display_name = {
    (local.groups.group1) = azuread_group.test[local.groups.group1].display_name
    (local.groups.group2) = azuread_group.test[local.groups.group2].display_name
  }
  groups_by_mail_nickname = {
    (local.groups.group1) = azuread_group.test[local.groups.group1].mail_nickname
    (local.groups.group3) = azuread_group.test[local.groups.group3].mail_nickname
  }
  groups_by_object_id = {
    (local.groups.group1) = azuread_group.test[local.groups.group1].object_id
    (local.groups.group4) = azuread_group.test[local.groups.group4].object_id
  }

  app_registrations_by_display_name = {
    (local.app_registrations.app_registration1) = azuread_application.test[local.app_registrations.app_registration1].display_name
    (local.app_registrations.app_registration2) = azuread_application.test[local.app_registrations.app_registration2].display_name
  }
  app_registrations_by_client_id = {
    (local.app_registrations.app_registration1) = azuread_application.test[local.app_registrations.app_registration1].client_id
    (local.app_registrations.app_registration3) = azuread_application.test[local.app_registrations.app_registration3].client_id
  }
  app_registrations_by_object_id = {
    (local.app_registrations.app_registration1) = azuread_application.test[local.app_registrations.app_registration1].object_id
    (local.app_registrations.app_registration4) = azuread_application.test[local.app_registrations.app_registration4].object_id
  }
  app_registrations_by_principal_id = {
    (local.app_registrations.app_registration1) = azuread_service_principal.test[local.app_registrations.app_registration1].object_id
    (local.app_registrations.app_registration5) = azuread_service_principal.test[local.app_registrations.app_registration5].object_id
  }

  system_assigned_managed_identities_by_display_name = {
    (local.system_assigned_managed_identities.sami1) = azurerm_static_site.test[local.system_assigned_managed_identities.sami1].name
    (local.system_assigned_managed_identities.sami2) = azurerm_static_site.test[local.system_assigned_managed_identities.sami2].name
  }
  system_assigned_managed_identities_by_principal_id = {
    (local.system_assigned_managed_identities.sami1) = azurerm_static_site.test[local.system_assigned_managed_identities.sami1].identity[0].principal_id
    (local.system_assigned_managed_identities.sami3) = azurerm_static_site.test[local.system_assigned_managed_identities.sami3].identity[0].principal_id
  }
  system_assigned_managed_identities_by_client_id = {
    (local.system_assigned_managed_identities.sami1) = data.azuread_service_principal.test[local.system_assigned_managed_identities.sami1].client_id
    (local.system_assigned_managed_identities.sami4) = data.azuread_service_principal.test[local.system_assigned_managed_identities.sami4].client_id
  }

  user_assigned_managed_identities_by_resource_group_and_name = {
    (local.user_assigned_managed_identities.uami1) = {
      name                = azurerm_user_assigned_identity.test[local.user_assigned_managed_identities.uami1].name
      resource_group_name = azurerm_user_assigned_identity.test[local.user_assigned_managed_identities.uami1].resource_group_name
    }
    (local.user_assigned_managed_identities.uami2) = {
      name                = azurerm_user_assigned_identity.test[local.user_assigned_managed_identities.uami2].name
      resource_group_name = azurerm_user_assigned_identity.test[local.user_assigned_managed_identities.uami2].resource_group_name
    }
  }
  user_assigned_managed_identities_by_display_name = {
    (local.user_assigned_managed_identities.uami1) = azurerm_user_assigned_identity.test[local.user_assigned_managed_identities.uami2].name
    (local.user_assigned_managed_identities.uami3) = azurerm_user_assigned_identity.test[local.user_assigned_managed_identities.uami2].name
  }
  user_assigned_managed_identities_by_client_id = {
    (local.user_assigned_managed_identities.uami1) = azurerm_user_assigned_identity.test[local.user_assigned_managed_identities.uami1].client_id
    (local.user_assigned_managed_identities.uami4) = azurerm_user_assigned_identity.test[local.user_assigned_managed_identities.uami4].client_id
  }
  user_assigned_managed_identities_by_principal_id = {
    (local.user_assigned_managed_identities.uami1) = azurerm_user_assigned_identity.test[local.user_assigned_managed_identities.uami1].principal_id
    (local.user_assigned_managed_identities.uami5) = azurerm_user_assigned_identity.test[local.user_assigned_managed_identities.uami5].principal_id
  }

  role_definitions = {
    role1 = "Owner"
    role2 = "Contributor"
    role3 = "Reader"
  }

  role_assignments_by_resource = {
    test1 = {
      resource_group_name = azurerm_resource_group.test.name
      resource_name       = azurerm_static_site.test[local.system_assigned_managed_identities.sami1].name
      role_assignments = {
        role_assignment1 = {
          role_definition                    = "role1"
          users                              = [local.users.user1, local.users.user4]
          groups                             = [local.groups.group1]
          app_registrations                  = [local.app_registrations.app_registration1]
          system_assigned_managed_identities = [local.system_assigned_managed_identities.sami1]
          user_assigned_managed_identities   = [local.user_assigned_managed_identities.uami1]
        }
        role_assignment2 = {
          role_definition                    = "role2"
          users                              = [local.users.user2]
          groups                             = [local.groups.group2]
          app_registrations                  = [local.app_registrations.app_registration2]
          system_assigned_managed_identities = [local.system_assigned_managed_identities.sami2]
          user_assigned_managed_identities   = [local.user_assigned_managed_identities.uami2]
        }
        role_assignment3 = {
          role_definition                    = "role3"
          users                              = [local.users.user3]
          groups                             = [local.groups.group3]
          app_registrations                  = [local.app_registrations.app_registration3]
          system_assigned_managed_identities = [local.system_assigned_managed_identities.sami3]
          user_assigned_managed_identities   = [local.user_assigned_managed_identities.uami3]
        }
      }
    }
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

- <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) (>= 3.7.0, < 4.0.0)

- <a name="provider_random"></a> [random](#provider\_random)

- <a name="provider_time"></a> [time](#provider\_time)

## Resources

The following resources are used by this module:

- [azuread_application.test](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application) (resource)
- [azuread_group.test](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/group) (resource)
- [azuread_service_principal.test](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/service_principal) (resource)
- [azuread_user.test](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/user) (resource)
- [azurerm_resource_group.test](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) (resource)
- [azurerm_static_site.test](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/static_site) (resource)
- [azurerm_user_assigned_identity.test](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/user_assigned_identity) (resource)
- [random_password.password](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/password) (resource)
- [random_pet.app_registration_display_name](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/pet) (resource)
- [random_pet.group_name](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/pet) (resource)
- [random_pet.resource_group_name](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/pet) (resource)
- [random_pet.static_site](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/pet) (resource)
- [random_pet.user_assigned_managed_identity](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/pet) (resource)
- [random_pet.username](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/pet) (resource)
- [random_string.employee_id](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/string) (resource)
- [time_sleep.before_service_principal_read_creation](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) (resource)
- [azuread_service_principal.test](https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/service_principal) (data source)

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

The following Modules are called:

### <a name="module_avm-ptn-authorization-roleassignment"></a> [avm-ptn-authorization-roleassignment](#module\_avm-ptn-authorization-roleassignment)

Source: ../../

Version:

<!-- markdownlint-disable-next-line MD041 -->
## Data Collection

The software may collect information about you and your use of the software and send it to Microsoft. Microsoft may use this information to provide services and improve our products and services. You may turn off the telemetry as described in the repository. There are also some features in the software that may enable you and Microsoft to collect data from users of your applications. If you use these features, you must comply with applicable law, including providing appropriate notices to users of your applications together with a copy of Microsoft’s privacy statement. Our privacy statement is located at <https://go.microsoft.com/fwlink/?LinkID=824704>. You can learn more about data collection and use in the help documentation and our privacy statement. Your use of the software operates as your consent to these practices.
<!-- END_TF_DOCS -->