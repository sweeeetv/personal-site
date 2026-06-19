#this file is for GitHub related resources, such as GitHub Actions secrets and federated identity credentials for GitHub OIDC authentication to Azure

# allows to retrieve information about the current Azure client (like tenant ID and subscription ID) to use in  GitHub Actions secrets and federated identity credentials.
data "azurerm_client_config" "current" {}

# frontend repo github action push to $web setup
# 1. Define the Frontend Repository
# This tells Terraform which repo we are talking to
data "github_repository" "frontend" {
  full_name = "sweeeetv/cloud_resume-frontend"
}

# 2. Automate the Tenant ID Secret
resource "github_actions_secret" "frontend_tenant_id" {
  repository      = data.github_repository.frontend.name
  secret_name     = "AZURE_TENANT_ID"
  plaintext_value = data.azurerm_client_config.current.tenant_id
}

# 3. Automate the Subscription ID Secret
resource "github_actions_secret" "frontend_subscription_id" {
  repository      = data.github_repository.frontend.name
  secret_name     = "AZURE_SUBSCRIPTION_ID"
  plaintext_value = data.azurerm_client_config.current.subscription_id
}

# 4. Automate the Client ID (The Managed Identity)
resource "github_actions_secret" "frontend_client_id" {
  repository      = data.github_repository.frontend.name
  secret_name     = "AZURE_CLIENT_ID"
  plaintext_value = azurerm_user_assigned_identity.frontend_identity_github_action.client_id
}



#################### GITHUB ACTIONS FOR FUNCTION APP (VISITOR COUNTER) ####################
# 1. Define the Backend Repository
data "github_repository" "backend" {
  full_name = "sweeeetv/cloud_resume-backend"
}
# 2. Automate the Tenant ID Secret for the Backend Repo
resource "github_actions_secret" "backend_tenant_id" {
  repository      = data.github_repository.backend.name
  secret_name     = "AZURE_TENANT_ID"
  plaintext_value = data.azurerm_client_config.current.tenant_id
}
# 3. Automate the Subscription ID Secret for the Backend Repo
resource "github_actions_secret" "backend_subscription_id" {
  repository      = data.github_repository.backend.name
  secret_name     = "AZURE_SUBSCRIPTION_ID"
  plaintext_value = data.azurerm_client_config.current.subscription_id
}
# 4. Automate the Client ID (The Managed Identity) for the Backend Repo
resource "github_actions_secret" "backend_client_id" {
  repository      = data.github_repository.backend.name
  secret_name     = "AZURE_CLIENT_ID"
  plaintext_value = azurerm_user_assigned_identity.backend_identity_github_action.client_id
}