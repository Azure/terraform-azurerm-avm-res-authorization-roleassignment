locals {
  role_definitions = { for key, value in data.azurerm_role_definition.role_definitions_by_name :
    key => value.id
  }
}

data "azurerm_role_definition" "role_definitions_by_name" {
  for_each = var.role_definitions
  name     = each.value
}
