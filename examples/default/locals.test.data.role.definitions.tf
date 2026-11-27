locals {
  # Owner, User Access Administrator, and RBAC Administrator are avoided because the test identity can't assign privileged roles.
  role_definitions = {
    role1 = { name = "Contributor" }
    role2 = { name = "Reader" }
    role3 = { name = "Storage Blob Data Reader" }
    role4 = { name = var.include_custom_role_definition ? "Example-Role" : "Storage Blob Data Contributor" } # Note the custom role `Example-Role` needs to be created manually as it takes too long to create one during the test.
    role5 = { id = "43d0d8ad-25c7-4714-9337-8ba259a9fe05" }
    role6 = { name = "Reader", scope = "/subscriptions/${data.azapi_client_config.current.subscription_id}" }
  }
}
