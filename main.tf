resource "azurerm_resource_group" "crc" {
  name     = "rg-resume"
  location = var.location
}

resource "azurerm_storage_account" "crc" {
  //name can only include lowercases and numbers
  name                     = "storageacc444resume"
  resource_group_name      = azurerm_resource_group.crc.name
  location                 = azurerm_resource_group.crc.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  access_tier              = "Hot"
  tags                     = var.tags
  //allow_nested_items_to_be_public = false
  custom_domain {
    name          = "pp.weirdcloud.dev"
    use_subdomain = false
  }
}

resource "azurerm_storage_account_static_website" "crc" {
  //more study on this part
  storage_account_id = azurerm_storage_account.crc.id
  error_404_document = "index.html"
  index_document     = "index.html"
}
