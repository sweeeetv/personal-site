resource "azurerm_resource_group" "resume" {
  name     = "rg-resume"
  location = var.location
}

//cd dev/site/infra