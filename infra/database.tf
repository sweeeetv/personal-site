resource "azurerm_cosmosdb_account" "counter_db" {
    name = "weirdcloud-counter-table-db"
    location = var.location
    resource_group_name = azurerm_resource_group.crc.name
    offer_type = "Standard"
    kind = "GlobalDocumentDB"
    automatic_failover_enabled = false
    public_network_access_enabled = true

  # backup {
  #   type = "Periodic"
  #   interval_in_minutes = 60
  #   retention_interval_in_hours = 8
  # }

  capabilities {
    name = "EnableServerless"
  }

  capabilities {
    name = "EnableTable"
  }

  consistency_policy {
    consistency_level = "Session"
  }

  geo_location {
    location          = var.location
    failover_priority = 0
    zone_redundant    = false
  }

  tags = var.tags
}

resource "azurerm_cosmosdb_table" "counter_table" {
  name                = "visiter-counter-table"
  resource_group_name = azurerm_resource_group.crc.name
  account_name        = azurerm_cosmosdb_account.counter_db.name
  #throughput not necessary for serverless accounts, but if you want to set it, you can uncomment the line below and set the desired throughput value
  #throughput          = 400
}