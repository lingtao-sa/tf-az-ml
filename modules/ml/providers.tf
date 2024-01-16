terraform {

  # cloud {
  #   organization = "xcelerent"

  #   workspaces {
  #     name = "az-ml-aus-dev"
  #   }
  # }
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.85.0"
    }

    random = {
      source  = "hashicorp/random"
      version = "3.6.0"
    }
  }

  required_version = ">= 1.6.0"
}