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

### data lakohouse v2

# resource "azurerm_storage_data_lake_gen2_filesystem" "lakehouse_strg" {
#   name               = "lakehouse_strg"
#   storage_account_id = azurerm_storage_account.main.id

#   properties = {
#     hello = "aGVsbG8="
#   }
# }

resource "azurerm_role_assignment" "logs_storage_access" {
  scope                = azurerm_storage_account.main.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_storage_account.main.identity[0].principal_id

  depends_on = [
    azurerm_storage_account.main,
  ]
}
