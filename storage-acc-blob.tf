resource "azurerm_storage_account" "main" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

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

resource "azuread_application" "main" {
  display_name = "iomete-aks"
}

resource "azuread_service_principal" "main" {
  application_id = azuread_application.main.application_id
}

resource "azurerm_role_assignment" "logs_storage_access" {
  scope                = azurerm_storage_account.main.id
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.main.object_id

  depends_on = [
    azurerm_storage_account.main,
    azuread_service_principal.main
  ]
}
