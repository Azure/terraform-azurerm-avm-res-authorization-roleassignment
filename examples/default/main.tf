terraform {
  required_version = ">= 1.3.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.7.0, < 4.0.0"
    }
  }
}

provider "azurerm" {
  features {}
}

module "avm-ptn-authorization-roleassignment" {
  source = "../../"
  # source = "Azure/avm-ptn-authorization-roleassignment/azurerm"
  enable_telemetry = var.enable_telemetry
  users = {
    user1 = {
      user_principal_name = "test-user-01@csutf.onmicrosoft.com"
      mail = "test.user.01@test.com"
      mail_nickname = "test-user-01"
      employee_id = "Test User 01 332"
      object_id = "4de4aa10-d0cf-4634-ae1c-fdc82361cd67"
    }
    user2 = {
      user_principal_name = "test-user-02@csutf.onmicrosoft.com"
    }
  }
  app_registrations = {
    app1 = {
      display_name = "test-application-01"
      client_id = "31df6c65-93ae-4214-b64b-8f63560ccaa5"
      object_id = "c4a2ee57-562a-49a7-9c67-74704d2a78eb"
      principal_id = "18848969-0a9f-47ab-8868-0ad193b40221"
    }
    app2 = {
      display_name = "test-application-02"
    }
  }
}


