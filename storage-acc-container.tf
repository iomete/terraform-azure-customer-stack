
## Azure AD application that represents the app
resource "azuread_application" "app" {
  display_name = "iomete-app-${local.cluster_name}"
}

resource "azuread_service_principal" "app" {
  application_id = azuread_application.app.application_id
  app_role_assignment_required = false
}
 
 
## Azure AD federated identity used to federate kubernetes with Azure AD
resource "azuread_application_federated_identity_credential" "monitoring" {
  application_object_id = azuread_application.app.object_id
  display_name          = "iomete-app-loki-credential"
  description           = "Loki service account federated credential"
  audiences             = ["api://AzureADTokenExchange"]
  issuer                = azurerm_kubernetes_cluster.main.oidc_issuer_url
  subject               = "system:serviceaccount:monitoring:loki-s3access-sa"
}
 
 resource "azuread_application_federated_identity_credential" "workspace" {
  application_object_id = azuread_application.app.object_id
  display_name          = "iomete-app-spark-credential"
  description           = "Kubernetes service account federated credential"
  audiences             = ["api://AzureADTokenExchange"]
  issuer                = azurerm_kubernetes_cluster.main.oidc_issuer_url
  subject               = "system:serviceaccount:workspace-*:spark-service-account"
}
 
  resource "azuread_application_federated_identity_credential" "iomete-system" {
  application_object_id = azuread_application.app.object_id
  display_name          = "iomete-app-iomete-system-credential"
  description           = "Kubernetes service account federated credential"
  audiences             = ["api://AzureADTokenExchange"]
  issuer                = azurerm_kubernetes_cluster.main.oidc_issuer_url
  subject               = "system:serviceaccount:iomete-system:*"
}

 


resource "azurerm_storage_account" "main" {
  name                     = local.storage_account_name
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"

  identity {
    type = "SystemAssigned"
  }

  tags = local.tags
}

resource "azurerm_storage_container" "assets" {
  name                  = "${local.cluster_name}-assets"
  storage_account_name  = azurerm_storage_account.main.name
  container_access_type = "private"
}

resource "azurerm_role_assignment" "logs_storage_access" {
  scope                = azurerm_storage_account.main.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azuread_service_principal.app.id

  depends_on = [
    azurerm_storage_account.main,
  ]
}
 

