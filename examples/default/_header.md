# Default example

This is an end to end example demonstrating the full functionlality of the module.

Since this module requires specific account name, this example creates them dynamically so we can use it for end to end testing without any specific dependencies.

Having said that, there is one specific dependency on a custom role definition called `Example-Role` in this example. This is due to the very slow API response when creating role definitions, which makes it unsuitable for end to end testing.

The parent management group defaults to the tenant root, identified by the tenant ID rather than its changeable display name. Set `test_management_group_display_name` to use a different existing management group. The deployment identity still needs access to that group; this example does not grant permissions.
