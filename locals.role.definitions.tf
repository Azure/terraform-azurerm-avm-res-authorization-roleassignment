locals {
  entra_id_role_definitions = { for key, value in azuread_directory_role.entra_id_role_definitions_by_name :
    key => {
      id = value.template_id
    }
  }
  role_definitions = { for key, value in data.azurerm_role_definition.role_definitions_by_name :
    key => {
      id     = value.id
      scopes = value.assignable_scopes
    }
  }
}

data "azurerm_role_definition" "role_definitions_by_name" {
  for_each = var.role_definitions

  name               = each.value.name
  role_definition_id = each.value.id
  scope              = each.value.scope
}

resource "azuread_directory_role" "entra_id_role_definitions_by_name" {
  for_each = var.entra_id_role_definitions

  display_name = each.value.display_name
  template_id  = each.value.template_id
}
