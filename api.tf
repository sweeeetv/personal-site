resource "azurerm_storage_account" "visiter_counter_storage" {
  name                     = "crcvisitercountersa"
  resource_group_name      = azurerm_resource_group.crc.name
  location                 = var.location
  account_tier             = "Standard"
  #It is the cheapest option. Local redundant storage.
  account_replication_type = "LRS"
  tags = var.tags
}
resource "azurerm_storage_container" "visiter_counter_func_blob_container" {
  name                  = "${var.visiter_counter_api_name}-blob-container"
  storage_account_id = azurerm_storage_account.visiter_counter_storage.id
  container_access_type = "private"
}

########## function app resources ##########
resource "azurerm_service_plan" "visiter_counter_plan" {
    name                = "${var.visiter_counter_api_name}_service_plan"
    resource_group_name = azurerm_resource_group.crc.name
    location            = var.location
    os_type             = "Linux"
    sku_name            = "FC1" 
    tags                = var.tags
}
resource "azurerm_function_app_flex_consumption" "visiter_counter_api" {
  name                = var.visiter_counter_api_name
  resource_group_name = azurerm_resource_group.crc.name
  location            = var.location
  service_plan_id     = azurerm_service_plan.visiter_counter_plan.id

  # Flex deployment storage
  storage_container_type      = "blobContainer"
  storage_container_endpoint  = "${azurerm_storage_account.visiter_counter_storage.primary_blob_endpoint}${azurerm_storage_container.visiter_counter_func_blob_container.name}/"
  storage_authentication_type = "StorageAccountConnectionString"
  storage_access_key          = azurerm_storage_account.visiter_counter_storage.primary_access_key

  # Runtime python 3.13
  runtime_name    = "python"
  runtime_version = "3.13"

  # Scale & memory max 100, memory 512
  maximum_instance_count = 2
  instance_memory_in_mb  = 512

  # environment variables for the function app.
  app_settings = {
    APPLICATIONINSIGHTS_CONNECTION_STRING = azurerm_application_insights.visiter_counter_appInsights.connection_string
    COSMOS_DB_CONNECTION_STRING = "DefaultEndpointsProtocol=https;AccountName=${azurerm_cosmosdb_account.counter_db.name};AccountKey=${azurerm_cosmosdb_account.counter_db.primary_key};TableEndpoint=https://${azurerm_cosmosdb_account.counter_db.name}.table.cosmos.azure.com:443/;"
   }

  site_config {
    cors {
      allowed_origins = [
        "https://${azurerm_storage_account.crc.primary_web_host}",
        "https://pp.weirdcloud.dev", 
        "http://localhost:5500"
      ]
    }
  }
}

#insights
resource "azurerm_log_analytics_workspace" "for_all_insights" {
  name                = "workspace-for-all-insights"
  resource_group_name = azurerm_resource_group.crc.name
  location            = var.location
  sku                 = "PerGB2018"
    retention_in_days   = 30
  tags                = var.tags
}
resource "azurerm_application_insights" "visiter_counter_appInsights" {
  name                = "${var.visiter_counter_api_name}-appInsights"
  resource_group_name = azurerm_resource_group.crc.name
  location            = var.location
  application_type     = "web"
  workspace_id = azurerm_log_analytics_workspace.for_all_insights.id
}