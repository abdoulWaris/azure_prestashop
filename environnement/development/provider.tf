terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~>3.1"
    }
  }
}

provider "azurerm" {
  features {}
}

locals {
  environment = "dev"
  common_tags = {
    Project     = "PrestaShop"
    Environment = local.environment
    Owner       = "Etudiant"
    Course      = "Infrastructure-Cloud"
  }
}