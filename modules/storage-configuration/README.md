# IOMETE Customer-Stack, Storage configuration mmodule

## Terraform module which creates S3 bucket and IAM role for new workspace.

## Usage example
 
```hcl

module "storage-configuration-[workspace-name]" {
  source                     = "iomete/customer-stack/azure//modules/storage-configuration"
  version                    = "1.0.0"
  storage_account_name = var.storage_account_name
  resource_group_name = var.resource_group_name
  storage_account_id = var.storage_account_id
  location = var.location
  container_name = var.container_name
}

#####################
# Outputs
#####################

output "container_name" {
  description = "A container name to be created. Lakehouse data will be stored in this container"
  value       = azurerm_storage_container.main.name
}
 

```

## Description of variables

| Name | Description | Required |
| --- | --- | --- |
| location | AKS region where cluster is deployed | yes |
| storage_account_name | Name of storage account for accessing blob storage | yes |
| container_name | Name of Blob sotrage container name for workspace | yes |

