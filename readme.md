# IOMETE Customer-Stack module

## Terraform module which creates resources on Azure.
 

## Module Usage

After install module will create the following resources in local directory (where you run terraform apply)

```shell

client_certificate.pem
client_key.pem
cluster_ca_certificate.pem

```
Open this file ordinary text editor and copy the content of the file to the IOMETE control plane.

## Terraform code

```hcl

 
 
module "customer-stack" {
  source     = "iomete/customer-stack/azure"
  version    = "1.0.0"
  cluster_id = "azure-customer"
  location   = "eastus" # Cluster installed region
  container_name = "iomete-cluster-lakehouse"
  storage_account_name = "iometeclusterstorageac" # Storage account name, must be unique across Azure(must containt only latters and numbers (no special characters [_-./] allowed))
  exec_max_count = 200 # Max number of executer nodes(virtual machines)
  driver_max_count = 3 # Max number of driver nodes(virtual machines)

}


###############################################
# Output
###############################################

output "cluster_name" {
  value       = module.customer-stack.aks_name
  description = "The name of the AKS cluster."
}

output "cluster_fqdn" {
  value       = module.customer-stack.cluster_fqdn
  description = "The IP address of the AKS cluster's Kubernetes API server endpoint."

}

output "client_certificate" {
  value       = module.customer-stack.client_certificate
  description = "The client certificate for authenticating to the AKS cluster."
  sensitive   = true

}

output "client_key" {
  value       = module.customer-stack.client_key
  description = "The client key for authenticating to the AKS cluster."
  sensitive   = true

}

output "cluster_ca_certificate" {
  value       = module.customer-stack.cluster_ca_certificate
  description = "The cluster CA certificate for the AKS cluster."
  sensitive   = true

}



  
```

## Terraform Deployment

```shell
terraform init
terraform plan
terraform apply
```

## Description of variables

| Name | Description | Required |
| --- | --- | --- |
| cluster_id | The name of the AKS cluster. | yes |
| location | The location of the AKS cluster. | yes |
| container_name | The name of the container where the cluster assets and lakehouse data will be stored. | yes |
| storage_account_name | torage account name, must be unique across Azure(must containt only latters and numbers (no special characters [_-./] allowed)) | yes |
| executer_max_count | Max number of spark executer nodes(virtual machines) | yes |
| driver_max_count | Max number of spark driver nodes(virtual machines) | yes |

