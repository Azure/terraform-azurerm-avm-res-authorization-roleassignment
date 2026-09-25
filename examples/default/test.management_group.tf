resource "random_pet" "management_group_name" {
  length    = 2
  separator = "-"
}

data "azapi_resource_list" "test_management_groups" {
  parent_id              = "/"
  type                   = "Microsoft.Management/managementGroups@2023-04-01"
  response_export_values = []
}

resource "azapi_resource" "management_group" {
  name = "${local.module_name}-${random_pet.management_group_name.id}"
  parent_id = one([
    for management_group in data.azapi_resource_list.test_management_groups.output :
    management_group.id
    if management_group.properties.displayName == var.test_management_group_display_name
  ])
  type = "Microsoft.Management/managementGroups@2023-04-01"
  body = {
    properties = {
      displayName = "${local.module_name}-${random_pet.management_group_name.id}"
      details = {
        parent = {
          id = one([
            for management_group in data.azapi_resource_list.test_management_groups.output :
            management_group.id
            if management_group.properties.displayName == var.test_management_group_display_name
          ])
        }
      }
    }
  }
  response_export_values = []
}

resource "time_sleep" "after_management_group_creation" {
  create_duration = "300s"

  depends_on = [azapi_resource.management_group]
}
