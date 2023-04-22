
resource "kubernetes_secret" "iom-manage-secrets" {
  metadata {
    name = "iomete-manage-secrets"
  }

  data = {
    "azure.settings" = jsonencode({
      region = var.location,
      cluster = {
        id   = var.cluster_id,
        name = local.cluster_name,
      },
      aks = {
        name                      = azurerm_kubernetes_cluster.main.name,
        endpoint                  = azurerm_kubernetes_cluster.main.kube_config.0.host,
        nat_public_ips            = azurerm_kubernetes_cluster.main.fqdn
      },
      default_storage_configuration = {
        storage_account_name        = azurerm_storage_account.main.name,
        azurerm_storage_account_key = azurerm_storage_account.main.primary_access_key
        azurerm_storage_container   = azurerm_storage_container.assets.name,

      },
      terraform = {
        module_version = local.module_version
      },
      # loki = {
      #   bucket           = aws_s3_bucket.assets.bucket
      #   cluster_role_arn = aws_iam_role.cluster_lakehouse.arn
      #   region           = var.region
      # },
    })
  }

  type = "opaque"

  depends_on = [
   azurerm_kubernetes_cluster.main
  ]
}


resource "kubernetes_secret" "blob-storage-secret" {
  metadata {
    name = "iomete-blob-storage-secret"
  }

  data = {
    "blob-storage.config" = jsonencode({
      region = var.location,
      data = {
        azurestorageaccountname   = azurerm_storage_account.main.name
        azurestorageaccountkey    = azurerm_storage_account.main.primary_access_key
      },
    })
  }

  type = "opaque"

  depends_on = [
   azurerm_kubernetes_cluster.main
  ]
}

resource "kubernetes_namespace" "fluxcd" {
  metadata {
    name = "fluxcd"
  }
}


resource "helm_release" "fluxcd" {
  name       = "helm-operator"
  namespace  = "fluxcd"
  repository = "https://fluxcd-community.github.io/helm-charts"
  version    = "2.3.0"
  chart      = "flux2"
  depends_on = [
    kubernetes_namespace.fluxcd
  ]
  set {
    name  = "imageReflectionController.create"
    value = "false"
  }

  set {
    name  = "imageAutomationController.create"
    value = "false"
  }

  set {
    name  = "kustomizeController.create"
    value = "false"
  }

  set {
    name  = "notificationController.create"
    value = "false"
  }


}
