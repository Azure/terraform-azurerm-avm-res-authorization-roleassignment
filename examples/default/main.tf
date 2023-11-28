terraform {
  required_version = ">= 1.3.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.7.0, < 4.0.0"
    }
    azuread = {
      source  = "hashicorp/azuread"
      version = ">= 2.0.0, < 3.0.0"
    }
  }
}

provider "azurerm" {
  features {}
}

locals {
  module_name                 = "avm-ptn-authorization-roleassignment"
  test_user_count             = 6
  test_app_registrstion_count = 5
}

module "avm-ptn-authorization-roleassignment" {
  source = "../../"
  # source = "Azure/avm-ptn-authorization-roleassignment/azurerm"
  enable_telemetry = var.enable_telemetry

  depends_on = [azuread_service_principal.test, azuread_user.test]

  users_by_user_principal_name = {
    user1 = azuread_user.test[0].user_principal_name
    user2 = azuread_user.test[1].user_principal_name
  }
  users_by_mail = {
    user1 = azuread_user.test[0].mail
    user3 = azuread_user.test[2].mail
  }
  users_by_mail_nickname = {
    user1 = azuread_user.test[0].mail_nickname
    user4 = azuread_user.test[3].mail_nickname
  }
  users_by_employee_id = {
    user1 = azuread_user.test[0].employee_id
    user5 = azuread_user.test[4].employee_id
  }
  users_by_object_id = {
    user1 = azuread_user.test[0].object_id
    user6 = azuread_user.test[5].object_id
  }

  app_registrations_by_display_name = {
    app1 = azuread_application.test[0].display_name
    app2 = azuread_application.test[1].display_name
  }
  app_registrations_by_client_id = {
    app1 = azuread_application.test[0].client_id
    app3 = azuread_application.test[2].client_id
  }
  app_registrations_by_object_id = {
    app1 = azuread_application.test[0].object_id
    app4 = azuread_application.test[3].object_id
  }
  app_registrations_by_principal_id = {
    app1 = azuread_service_principal.test[0].object_id
    app5 = azuread_service_principal.test[4].object_id
  }
}


