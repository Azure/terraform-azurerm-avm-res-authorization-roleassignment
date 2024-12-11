# Basic v3 example

This is an end to end example demonstrating the full functionlality of the module using the AzureRM provider version 3.7.

Since this module requires specific account name, this example creates them dynamically so we can use it for end to end testing without any specific dependencies.

Having said that, there is one specific dependency on a custom role definition called `Example-Role` in this example. This is due to the very slow API response when creating role definitions, which makes it unsuitable for end to end testing.
