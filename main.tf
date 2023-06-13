data "azurerm_client_config" "current" {}

resource "random_id" "random" {
  byte_length = 5
}
  
locals {
  cluster_name         = "iomete-${var.cluster_id}"
  storage_account_name = "iomdataplane${random_id.random.hex}"
  module_version       = "1.0.0"

  tags = {
    "iomete.com-cluster_id" : var.cluster_id
    "iomete.com-cluster_name" : local.cluster_name
    "iomete.com-terraform" : true
    "iomete.com-managed" : true
  }
}



provider "kubernetes" {
  host                   = azurerm_kubernetes_cluster.main.kube_config.0.host
  client_certificate     = base64decode(azurerm_kubernetes_cluster.main.kube_config.0.client_certificate)
  client_key             = base64decode(azurerm_kubernetes_cluster.main.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.main.kube_config.0.cluster_ca_certificate)
}

provider "helm" {
  kubernetes {
    host                   = azurerm_kubernetes_cluster.main.kube_config.0.host
    client_certificate     = base64decode(azurerm_kubernetes_cluster.main.kube_config.0.client_certificate)
    client_key             = base64decode(azurerm_kubernetes_cluster.main.kube_config.0.client_key)
    cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.main.kube_config.0.cluster_ca_certificate)
  }
}

resource "null_resource" "save_outputs" {
  depends_on = [
    azurerm_kubernetes_cluster_node_pool.standard_d16plds_v5
  ]
  triggers = {
    run_every_time = uuid()
  }
  provisioner "local-exec" {
    command = <<-EOT

      if [ ! -s "IOMETE_DATA" ]; then
      echo "Client Certificate: $(terraform output client_certificate)" >> IOMETE_DATA
      echo "Client Key: $(terraform output client_key)" >> IOMETE_DATA
      echo "Cluster CA: $(terraform output cluster_ca_certificate)" >> IOMETE_DATA
      echo "AKS Endpoint: $(terraform output cluster_fqdn)" >> IOMETE_DATA
      echo "AKS Name: $(terraform output cluster_name)" >> IOMETE_DATA
      fi


    EOT
  }
}

module "storage-configuration" {
  source = "./modules/storage-configuration"

  storage_account_name = azurerm_storage_account.main.name
  resource_group_name  = azurerm_resource_group.main.name
  location             = var.location
  cluster_name         = local.cluster_name

}




