data "azurerm_subscription" "current" {}

resource "kubernetes_secret" "iom-manage-secrets" {

  metadata {
    name = "iomete-manage-secrets"
  }

  data = {
    "azure.settings" = jsonencode({
      region = var.location,
      cluster = {
        id                                = var.cluster_id,
        name                              = local.cluster_name,
        resource_group_name               = azurerm_resource_group.main.name
        node_resource_group_name          = azurerm_kubernetes_cluster.main.node_resource_group
        azurerm_subscription_tenant_id    = data.azurerm_subscription.current.tenant_id
        azurerm_subscription_display_name = data.azurerm_subscription.current.display_name

      },
      workload = {
        tenant_id = data.azurerm_client_config.current.tenant_id,
        #client_id = data.azurerm_client_config.current.client_id,
        oidc_issuer_url = azurerm_kubernetes_cluster.main.oidc_issuer_url,
        client_id = azuread_service_principal.app.application_id,
      },

      aks = {
        name           = azurerm_kubernetes_cluster.main.name,
        endpoint       = azurerm_kubernetes_cluster.main.kube_config.0.host,
        nat_public_ips = azurerm_kubernetes_cluster.main.fqdn
      },
      default_storage_configuration = {
        storage_account_id   = azurerm_storage_account.main.id,
        storage_account_name = azurerm_storage_account.main.name,
        storage_account_key  = azurerm_storage_account.main.primary_access_key
        storage_container    = module.storage-configuration.container_name
        assets_container     = azurerm_storage_container.assets.name,

      },
      terraform = {
        module_version = local.module_version
      },

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
        azurestorageaccountname = azurerm_storage_account.main.name
        azurestorageaccountkey  = azurerm_storage_account.main.primary_access_key
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
