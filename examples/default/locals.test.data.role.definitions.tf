locals {
  entra_id_role_definitions = {
    role1 = "Directory Readers"
    role2 = "Directory Writers"
    role3 = "Application Administrator"
  }
  role_definitions = {
    role1 = "Owner"
    role2 = "Contributor"
    role3 = "Reader"
    role4 = var.include_custom_role_definition ? "Example-Role" : "User Access Administrator" # Note the custom role `Example-Role` needs to be created manually on the Tenant Root Group MG as it takes too long to create one during the test.
  }
}
