# IOMETE Customer-Stack, Storage configuration mmodule

## Terraform module which creates S3 bucket and IAM role for new workspace.

## Usage example
 
```hcl

module "storage-configuration-[workspace-name]" {
  source                     = "iomete/azure-data-plane/azure//modules/storage-configuration"
  version                    = "1.0.0"
  resource_group_name = "cluster resource group name"
  location = "cluster installed location"
  cluster_name = "existing_cluster_name"
}

#####################
# Outputs
#####################

output "container_name" {
  description = "A container name to be created. Lakehouse data will be stored in this container"
  value       = azurerm_storage_container.main.name
}
 

 output "storage_account_name" {
  description = "A container name to be created. Lakehouse data will be stored in this container"
  value       = azurerm_storage_account.main.name
}

```

## Description of variables

| Name | Description | Required |
| --- | --- | --- |
| location | AKS region where cluster is deployed | yes |
| resource_group_name | Cluster installed resource group name | yes |
| cluster_name | Existing cluster name | yes |

