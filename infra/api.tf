
resource "azurerm_storage_container" "visiter_counter_func_blob_container" {
  name                  = "${var.vc_api_name}-blob-container"
  storage_account_id = azurerm_storage_account.visiter_counter_storage.id
  container_access_type = "private"
}

########## function app resources ##########
//Azure Function App on Consumption Plan (Linux) with Python runtime, using the new flex deployment model, which decouples the function app from the underlying hosting plan and allows for more flexible scaling and configuration options. It also supports the latest Python runtime versions and has better cold start performance compared to the traditional consumption plan.
resource "azurerm_service_plan" "visitor_counter_plan" {
    name                = "${var.vc_api_name}_service_plan"
    resource_group_name = azurerm_resource_group.resume.name
    location            = var.location
    os_type             = "Linux"
    sku_name            = "FC1" 
    tags                = var.tags
}
resource "azurerm_function_app_flex_consumption" "visitor_counter_api" {
  name                = var.vc_api_name
  resource_group_name = azurerm_resource_group.resume.name
  location            = var.location
  service_plan_id     = azurerm_service_plan.visitor_counter_plan.id

  # Flex deployment storage
  storage_container_type      = "blobContainer"
  storage_container_endpoint  = "${azurerm_storage_account.visitor_counter_storage.primary_blob_endpoint}${azurerm_storage_container.visitor_counter_func_blob_container.name}/"
  storage_authentication_type = "StorageAccountConnectionString"
  storage_access_key          = azurerm_storage_account.visitor_counter_storage.primary_access_key

  # Runtime python 3.13
  runtime_name    = "python"
  runtime_version = "3.13"

  # Scale & memory max 100, memory 512
  maximum_instance_count = 2
  instance_memory_in_mb  = 512

  # environment variables for the function app.
  app_settings = {
    APPLICATIONINSIGHTS_CONNECTION_STRING = azurerm_application_insights.visitor_counter_appInsights.connection_string
    COSMOS_DB_CONNECTION_STRING = "DefaultEndpointsProtocol=https;AccountName=${azurerm_cosmosdb_account.counter_db.name};AccountKey=${azurerm_cosmosdb_account.counter_db.primary_key};TableEndpoint=https://${azurerm_cosmosdb_account.counter_db.name}.table.cosmos.azure.com:443/;"
   }

  site_config {
    cors {
      allowed_origins = [
        "https://${azurerm_storage_account.resume.primary_web_host}",
        "https://pp.weirdcloud.dev", 
        "http://localhost:5500"
      ]
    }
  }
}

#insights
resource "azurerm_log_analytics_workspace" "for_all_insights" {
  name                = "workspace-for-all-insights"
  resource_group_name = azurerm_resource_group.resume.name
  location            = var.location
  sku                 = "PerGB2018"
    retention_in_days   = 30
  tags                = var.tags
}
resource "azurerm_application_insights" "visitor_counter_appInsights" {
  name                = "${var.vc_api_name}-appInsights"
  resource_group_name = azurerm_resource_group.resume.name
  location            = var.location
  application_type     = "web"
  workspace_id = azurerm_log_analytics_workspace.for_all_insights.id
}