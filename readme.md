# IOMETE Customer-Stack module

## Terraform module which creates resources on Azure.
 

## Module Usage

  
## Terraform code

```hcl


module "customer-stack" {
  source     = "iomete/customer-stack/azure"
  version    = "1.0.0"
  cluster_id = "iomete-cls"
}



###############################################
# Outputs
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
 