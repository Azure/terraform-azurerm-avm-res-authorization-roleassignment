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

module "MYMODULE" {
  source = "../../"
  # source             = "Azure/avm-<res/ptn>-<name>/azurerm"
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
}


