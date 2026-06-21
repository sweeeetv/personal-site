terraform {
  // 1. Use a recent Terraform version (1.10+)
  required_version = ">= 1.10.0"
  required_providers {
    //azurerm provider is required to manage Azure resources
    azurerm = {
      source = "hashicorp/azurerm"
      # 2. Use the latest major version (4.x)
      version = "~> 4.0"
    } 
    # github = {
    #   source = "integrations/github"
    #   version = "~> 6.0"
    # }
    # cloudflare = {
    #   source = "cloudflare/cloudflare"
    #   version = "~> 4.0"
    # }
  }
  #store the tfstate files in my blob storage that provisioned for this state files.
  backend "azurerm" {
    resource_group_name  = "rg-terraform-state"
    storage_account_name = "tfstatepersonalxgao"
    container_name       = "tfstate"
    key                  = "resume.terraform.tfstate"//the name of the tfstate file in the blob storage.
  }
} 
//provider - when you/terraform need to check or change real Azure resources, call the Azure API, authenticated against this subscription
provider "azurerm" {
  subscription_id = "bcd4fe40-938d-48e2-bea9-6425a552c4ab"
  features {
  }//required by the provider but can be empty for now.
}

# provider "github" {
#   owner = "sweeeetv"
#   token = var.github_token 
# }

# provider "cloudflare" {
#   api_token = var.cloudflare_api_token
# }