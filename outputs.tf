//outputs.tf should not be in the .gitignore 
output "website_url" {
  description = "/subscriptions/bcd4fe40-938d-48e2-bea9-6425a552c4ab/resourceGroups/rg-resume/providers/Microsoft.Storage/storageAccounts/storageacc444resume/blobServices/default"
  value       = azurerm_storage_account.crc.primary_web_endpoint
}

output "storage_account_id" {
  value = azurerm_storage_account.crc.id
}

output "cosmos_endpoint" {
  value = azurerm_cosmosdb_account.counter_db.endpoint
}


# 3 ids for github action OIDC trust and RBAC
output "client_id" {
  value = azurerm_user_assigned_identity.frontend_identity_github_action.client_id
}
output "tenant_id" {
  value = azurerm_user_assigned_identity.frontend_identity_github_action.tenant_id
}
output "gha_subscription_id" {
  value = data.azurerm_client_config.current.subscription_id  
}

# output "cosmos_primary_key" {
#   value = azurerm_cosmosdb_account.counter_db.primary_master_key
#   sensitive = true
# }