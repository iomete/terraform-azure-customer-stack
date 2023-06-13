locals {

  tags = {
    "iomete.com-terraform" : true
    "iomete.com-managed" : true
  }
}

data "azurerm_storage_account" "existing" {
  name                = var.storage_account_name
  resource_group_name = var.resource_group_name
}

resource "random_id" "strg_random" {
  byte_length = 5
}


## Azure AD application that represents the app
resource "azuread_application" "workspace-app" {
  count = length(data.azurerm_storage_account.existing) > 0 ? 0 : 1
  display_name = "iomete-app-${var.cluster_name}"
}

resource "azuread_service_principal" "workspace-app" {
  count = length(data.azurerm_storage_account.existing) > 0 ? 0 : 1
  application_id           = azuread_application.workspace-app[count.index].application_id
  app_role_assignment_required = false
}
 

resource "azurerm_storage_account" "module_strg_acct" {
  count = length(data.azurerm_storage_account.existing) > 0 ? 0 : 1
  name  = length(data.azurerm_storage_account.existing) > 0 ? var.storage_account_name : "iomdataplane${random_id.strg_random.hex}"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"

  identity {
    type = "SystemAssigned"
  }

  tags = local.tags
}


resource "azurerm_storage_container" "main" {
  name                  = "${var.cluster_name}-lakehouse"
  storage_account_name  = var.storage_account_name
  container_access_type = "private"

 }
 resource "azurerm_role_assignment" "lakehouse_storage_access" {
  count                = length(azurerm_storage_account.module_strg_acct) > 0 ? length(azurerm_storage_account.module_strg_acct) : 0
  scope                = length(azurerm_storage_account.module_strg_acct) > 0 ? azurerm_storage_account.module_strg_acct[count.index].id : null
  role_definition_name = length(azurerm_storage_account.module_strg_acct) > 0 ? "Storage Blob Data Contributor" : null
  principal_id         = length(azurerm_storage_account.module_strg_acct) > 0 ? azurerm_storage_account.module_strg_acct[count.index].identity[0].principal_id : null
}




