output "container_name" {
  description = "A container name to be created. Lakehouse data will be stored in this container"
  value       = azurerm_storage_container.main.name
}
 