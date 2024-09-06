locals {
  entra_id_role_definitions = {
    role1 = { display_name = "Directory Readers" }
    role2 = { display_name = "Directory Writers" }
    role3 = { display_name = "Application Administrator" }
    role4 = { template_id = "9b895d92-2cd3-44c7-9d02-a6ac2d5ea5c3" }
  }
  role_definitions = {
    role1 = { name = "Owner" }
    role2 = { name = "Contributor" }
    role3 = { name = "Reader" }
    role4 = { name = var.include_custom_role_definition ? "Example-Role" : "User Access Administrator" } # Note the custom role `Example-Role` needs to be created manually on the Tenant Root Group MG as it takes too long to create one during the test.
    role5 = { id = "8e3af657-a8ff-443c-a75c-2fe8c4bcb635" }
    role6 = { name = "Owner", scope = "/subscriptions/${data.azurerm_client_config.current.subscription_id}" }
  }
}
