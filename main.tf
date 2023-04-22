data "azurerm_client_config" "current" {}

# provider "azurerm" {
#   features {
#     resource_group {
#       prevent_deletion_if_contains_resources = false
#     }
#   }

#   subscription_id   = var.azure_subscription_id
#   tenant_id         = var.azure_subscription_tenant_id
#   client_id         = var.service_principal_appid
#   client_secret     = var.service_principal_password
# }

locals {
  cluster_name   = "iomete-${var.cluster_id}"
  module_version = "1.0.0"

  tags = {
    "iomete.com-cluster_id" : var.cluster_id
    "iomete.com-cluster_name" : local.cluster_name
    "iomete.com-terraform" : true
    "iomete.com-managed" : true
  }
}
 


provider "kubernetes" {
  host                   = "${azurerm_kubernetes_cluster.main.kube_config.0.host}"
  client_certificate     = "${base64decode(azurerm_kubernetes_cluster.main.kube_config.0.client_certificate)}"
  client_key             = "${base64decode(azurerm_kubernetes_cluster.main.kube_config.0.client_key)}"
  cluster_ca_certificate = "${base64decode(azurerm_kubernetes_cluster.main.kube_config.0.cluster_ca_certificate)}"
}

provider "helm" {
  kubernetes {
    host                   = "${azurerm_kubernetes_cluster.main.kube_config.0.host}"
    client_certificate     = "${base64decode(azurerm_kubernetes_cluster.main.kube_config.0.client_certificate)}"
    client_key             = "${base64decode(azurerm_kubernetes_cluster.main.kube_config.0.client_key)}"
    cluster_ca_certificate = "${base64decode(azurerm_kubernetes_cluster.main.kube_config.0.cluster_ca_certificate)}"
  }
}




resource "null_resource" "save_outputs" {
  depends_on = [
    azurerm_kubernetes_cluster_node_pool.driver
  ]
  provisioner "local-exec" {
    command = <<-EOT
      terraform output client_certificate > client_certificate.pem &&
      terraform output client_key > client_key.pem &&
      terraform output cluster_ca_certificate > cluster_ca_certificate.pem
    EOT
  }
}
