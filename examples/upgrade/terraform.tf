terraform {
  required_version = "~> 1.6"

  required_providers {
    azapi = {
      source  = "Azure/azapi"
      version = "~> 2.12"
    }
    # tflint-ignore: terraform_unused_required_providers
    azuread = {
      source  = "hashicorp/azuread"
      version = ">= 2.46, < 4.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
  }
}
