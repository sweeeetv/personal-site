#frontend repo github action push to $web setup
#Identity
resource "azurerm_user_assigned_identity" "frontend_identity_github_action" {
  name                = "${var.project}-frontend-identity"
  resource_group_name = azurerm_resource_group.crc.name
  location            = var.location
    tags                = var.tags
}
#Handshake rule for the frontend REPO - this creates the "handshake" between Azure and GitHub OIDC, allowing the GitHub Action to authenticate to Azure using the identity we just created
resource "azurerm_federated_identity_credential" "frontend_federated_identity_github_action" {
    name                       = "${var.project}-frontend-federated-identity"
    resource_group_name        = azurerm_resource_group.crc.name
    parent_id                   = azurerm_user_assigned_identity.frontend_identity_github_action.id

    #github OIDC issuer
    issuer                     = "https://token.actions.githubusercontent.com"
    audience                   = ["api://AzureADTokenExchange"]
    subject                    = "repo:sweeeetv/cloud_resume-frontend:ref:refs/heads/main"
}
#assigns role to the identity, RBAC for frontend github action to access storage account and deploy to $web
resource "azurerm_role_assignment" "frontend_storage_blob_data_contributor" {
  scope                = azurerm_storage_account.crc.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_user_assigned_identity.frontend_identity_github_action.principal_id
}

######################## BACKEND CONFIGURATION ########################
# 1. Create the Identity for the Backend
resource "azurerm_user_assigned_identity" "backend_identity_github_action" {
  name                = "${var.project}-backend-identity"
  resource_group_name = azurerm_resource_group.crc.name
  location            = var.location
    tags                = var.tags
}

# 2. Create the "Handshake" rule for the Backend REPO
resource "azurerm_federated_identity_credential" "backend_federated_identity_github_action" {
  name                = "${var.project}-backend-federated-identity"
  resource_group_name = azurerm_resource_group.crc.name
  parent_id           = azurerm_user_assigned_identity.backend_identity_github_action.id

  #github OIDC issuer  
  audience            = ["api://AzureADTokenExchange"]
  issuer              = "https://token.actions.githubusercontent.com"
  subject             = "repo:sweeeetv/cloud_resume-backend:ref:refs/heads/main"
}

# 3. Give that identity permission to manage the Resource Group
resource "azurerm_role_assignment" "backend_contributor" {
  scope                = azurerm_resource_group.crc.id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.backend_identity_github_action.principal_id
}