output "container_name" {
  description = "A container name to be created. Lakehouse data will be stored in this container"
  value       = azurerm_storage_container.main.name
}
 output "storage_account_name" {
  description = "Newly created Storage account name"
  value       = length(azurerm_storage_account.module_strg_acct) > 0 ? azurerm_storage_account.module_strg_acct[0].name : null
}
