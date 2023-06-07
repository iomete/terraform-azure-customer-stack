resource "azurerm_resource_group" "main" {
  name     = "${local.cluster_name}-rg"
  location = var.location
  tags     = local.tags
}

###############################################
# Virtual Network
###############################################
resource "azurerm_virtual_network" "azure-iom" {
  depends_on = [
    azurerm_resource_group.main
  ]
  address_space       = ["10.10.0.0/16"]
  location            = azurerm_resource_group.main.location
  name                = "${local.cluster_name}-vn"
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_subnet" "azure-iom" {
  address_prefixes     = ["10.10.0.0/22"]
  name                 = "${local.cluster_name}-sn"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.azure-iom.name
  depends_on = [
    azurerm_resource_group.main
  ]
}

###############################################
# AKS Cluster
###############################################


resource "azurerm_kubernetes_cluster" "main" {
  name = local.cluster_name
  ### choose the resource goup to use for the cluster
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  node_resource_group = "${local.cluster_name}-nrg"
  dns_prefix          = local.cluster_name
  kubernetes_version  = var.orchestrator_version


  default_node_pool {
    name                        = "systempool"
    zones                       = [1]
    node_count                  = 1
    min_count                   = 1
    max_count                   = 3
    max_pods                    = 110
    vm_size                     = var.system_vm_size
    vnet_subnet_id              = azurerm_subnet.azure-iom.id
    type                        = "VirtualMachineScaleSets"
    enable_auto_scaling         = true
    enable_host_encryption      = false
    temporary_name_for_rotation = "nodeupgrade"
  }

  auto_scaler_profile {
    scale_down_delay_after_add    = "1m"
    scale_down_unneeded           = "1m"
    scale_down_unready            = "1m"
    max_graceful_termination_sec  = "30"
    skip_nodes_with_local_storage = false

  }
  tags = local.tags
  network_profile {
    network_plugin    = "azure"
    load_balancer_sku = "standard"
  }

  identity {
    type = "SystemAssigned"
  }

  http_application_routing_enabled = false
  depends_on = [
    azurerm_resource_group.main
  ]


}

###############################################
# driver pool
###############################################

resource "azurerm_kubernetes_cluster_node_pool" "standard_e2pds_v5" {
  name                  = "stde2pdsv5dr"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.main.id
  vm_size               = "Standard_E2ps_v5"
  node_count            = 0
  enable_auto_scaling   = true
  min_count             = null
  max_count             = var.driver_max_count
  priority              = "Regular"
  os_type               = "Linux"
  orchestrator_version  = var.orchestrator_version
  vnet_subnet_id        = azurerm_subnet.azure-iom.id


  #os_disk_size_gb = 30
  tags = local.tags
  node_labels = {
    "k8s.iomete.com/node-purpose" = "stde2pdsv5dr"
  }

  node_taints = ["k8s.iomete.com/dedicated=stde2pdsv5dr:NoSchedule"]

  depends_on = [azurerm_kubernetes_cluster.main]

}

resource "azurerm_kubernetes_cluster_node_pool" "standard_e4ps_v5" {
  name                  = "stde4psv5"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.main.id
  vm_size               = "Standard_E4ps_v5"
  node_count            = 0
  enable_auto_scaling   = true
  min_count             = null
  max_count             = var.driver_max_count
  priority              = "Regular"
  os_type               = "Linux"
  orchestrator_version  = var.orchestrator_version
  vnet_subnet_id        = azurerm_subnet.azure-iom.id


  #os_disk_size_gb = 30
  tags = local.tags
  node_labels = {
    "k8s.iomete.com/node-purpose" = "stde4psv5"
  }

  node_taints = ["k8s.iomete.com/dedicated=stde4psv5:NoSchedule"]

  depends_on = [azurerm_kubernetes_cluster.main]

}



##############################################
# executer pool
##############################################

resource "azurerm_kubernetes_cluster_node_pool" "standard_e2pds_v5_exec" {
  name                  = "stde2pdsv5"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.main.id
  vm_size               = "Standard_E2pds_v5"
  node_count            = 0
  enable_auto_scaling   = true
  min_count             = null
  max_count             = var.exec_max_count
  priority              = "Regular"
  os_type               = "Linux"
  orchestrator_version  = var.orchestrator_version
  vnet_subnet_id        = azurerm_subnet.azure-iom.id


  #os_disk_size_gb = 30
  tags = local.tags
  node_labels = {
    "k8s.iomete.com/node-purpose" = "stde2pdsv5"
  }

  node_taints = ["k8s.iomete.com/dedicated=stde2pdsv5:NoSchedule"]

  depends_on = [azurerm_kubernetes_cluster.main]

}


resource "azurerm_kubernetes_cluster_node_pool" "standard_e4pds_v5" {
  name                  = "stde4pdsv5"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.main.id
  vm_size               = "Standard_E4pds_v5"
  node_count            = 0
  enable_auto_scaling   = true
  min_count             = null
  max_count             = var.exec_max_count
  priority              = "Regular"
  os_type               = "Linux"
  orchestrator_version  = var.orchestrator_version
  vnet_subnet_id        = azurerm_subnet.azure-iom.id


  #os_disk_size_gb = 30
  tags = local.tags
  node_labels = {
    "k8s.iomete.com/node-purpose" = "stde4pdsv5"
  }

  node_taints = ["k8s.iomete.com/dedicated=stde4pdsv5:NoSchedule"]

  depends_on = [azurerm_kubernetes_cluster.main]

}


resource "azurerm_kubernetes_cluster_node_pool" "standard_d16plds_v5" {
  name                  = "std16pldsv5"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.main.id
  vm_size               = "Standard_D16plds_v5"
  node_count            = 0
  enable_auto_scaling   = true
  min_count             = null
  max_count             = var.exec_max_count
  priority              = "Regular"
  os_type               = "Linux"
  orchestrator_version  = var.orchestrator_version
  vnet_subnet_id        = azurerm_subnet.azure-iom.id


  tags = local.tags
  node_labels = {
    "k8s.iomete.com/node-purpose" = "std16pldsv5"
  }

  node_taints = ["k8s.iomete.com/dedicated=std16pldsv5:NoSchedule"]

  depends_on = [azurerm_kubernetes_cluster.main]

}

