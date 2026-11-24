# Default example

This is an end-to-end example of the module's Azure Resource Manager role assignments at resource, resource group, subscription, management group, and arbitrary scopes.

The principals are managed identities that the example creates through Azure Resource Manager, plus the identity running Terraform. The example creates no Entra ID users, groups, or app registrations, so it needs no Microsoft Graph write permissions. It also assigns only non-privileged roles, such as Contributor and Reader.

The test management group's parent defaults to the tenant root management group, which is identified by the tenant ID. Set `test_management_group_display_name` to use a different existing management group.

Set `include_custom_role_definition` to `true` to test a custom role definition called `Example-Role`. That role must already exist, because creating role definitions during the test is too slow.
