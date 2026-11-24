resource "random_pet" "management_group_name" {
  length    = 2
  separator = "-"
}

data "azapi_resource_list" "test_management_groups" {
  count = var.test_management_group_display_name == null ? 0 : 1

  parent_id              = "/"
  type                   = "Microsoft.Management/managementGroups@2023-04-01"
  response_export_values = ["value"]
}

locals {
  # The tenant root's name is always the tenant ID. Build its ID directly because the test identity may not see the root in a management group list.
  test_parent_management_group_id = var.test_management_group_display_name == null ? "/providers/Microsoft.Management/managementGroups/${data.azapi_client_config.current.tenant_id}" : one([
    for management_group in one(data.azapi_resource_list.test_management_groups[*].output).value :
    management_group.id
    if management_group.properties.displayName == var.test_management_group_display_name
  ])
}

resource "azapi_resource" "management_group" {
  name      = "${local.module_name}-${random_pet.management_group_name.id}"
  parent_id = "/"
  type      = "Microsoft.Management/managementGroups@2023-04-01"
  body = {
    properties = {
      displayName = "${local.module_name}-${random_pet.management_group_name.id}"
      details = {
        parent = {
          id = local.test_parent_management_group_id
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
