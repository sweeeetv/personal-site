terraform {
  # 1. Stay modern (matching 2026 standards)
  required_version = ">= 1.10.0"

  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      # 2. Use the latest major version (4.x)
      version = "~> 4.0"
    }
  }
  # 4. store tfstate in Azure Storage with a unique key
  backend "azurerm" {
    resource_group_name  = "rg-terraform-state"
    storage_account_name = "resume1771739033"
    container_name       = "tfstate"
    key                  = "resume-core.terraform.tfstate"
  }
}

provider "azurerm" {
  # 3. Explicitly target your subscription to prevent "Identity Confusion"
  subscription_id = "bcd4fe40-938d-48e2-bea9-6425a552c4ab"
  features {
  }
}

provider "github" {
  owner = "sweeeetv"
  token = var.github_token
}