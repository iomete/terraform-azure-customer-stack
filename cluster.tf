resource "azurerm_resource_group" "main" {
  name     = "${var.resource_group_name}"
  location = var.location
  tags = {
    Environment = "test"
    Team        = "SRE"
  }
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
  address_prefixes                          = ["10.10.0.0/22"]
  name                                      = "${local.cluster_name}-sn"
  resource_group_name                       = azurerm_resource_group.main.name
  virtual_network_name                      = azurerm_virtual_network.azure-iom.name
  depends_on = [
    azurerm_resource_group.main
  ]
}
 

###############################################
# service principal
###############################################

# resource "azuread_application" "main" {
#   display_name = "iomete-aks"
#  }

# resource "azuread_service_principal" "main" {
#   application_id = azuread_application.main.application_id
# }

# resource "azuread_service_principal_password" "main" {
#   service_principal_id = azuread_service_principal.main.id
#   end_date             = "2099-01-01T01:00:00Z"
# }

 
# resource "azurerm_role_assignment" "main" {
#   scope              = azurerm_kubernetes_cluster.main.id
#   role_definition_name = "Contributor"
#   principal_id       = azuread_application.main.application_id
# }
  

###############################################
# AKS Cluster
###############################################


resource "azurerm_kubernetes_cluster" "main" {
  name = local.cluster_name
  ### choose the resource goup to use for the cluster
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  ### decide the name of the cluster "node" resource group, if unset will be named automatically 
  node_resource_group = var.node_resource_group_name
  dns_prefix          = local.cluster_name
  kubernetes_version  = var.orchestrator_version
 
  # sku_tier = "Paid"

  default_node_pool {
    name       = "default"
    node_count = 1
    min_count  = 1
    max_count  = 3
    vm_size    = var.vm_size
    vnet_subnet_id = azurerm_subnet.azure-iom.id

    type                   = "VirtualMachineScaleSets"
    enable_auto_scaling    = true
    enable_host_encryption = false
    # os_disk_size_gb = 30
  }
  tags = {
    "iomete.com-managed"   = "true"
    "iomete.com-terraform" = "true"
    "version"              = "1.0"
  }
  network_profile {
    network_plugin = "azure"
    load_balancer_sku = "standard"
  }

  # service_principal {
  #   client_id     = azuread_application.main.application_id
  #   client_secret = azuread_service_principal_password.main.value
  # }

  identity {
    type = "SystemAssigned"
  }

  http_application_routing_enabled = false
  depends_on = [
    azurerm_resource_group.main
  ]


}
 
#######################
# node pool
#######################

 resource "azurerm_kubernetes_cluster_node_pool" "driver" {
  name                  = "driver"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.main.id
  vm_size               = var.vm_size
  node_count            = 1
  enable_auto_scaling = true
  min_count = 1
  max_count = 3
  priority = "Regular"
  os_type = "Linux"
  orchestrator_version = var.orchestrator_version
  vnet_subnet_id = azurerm_subnet.azure-iom.id
  #os_disk_size_gb = 30
  tags = {
    "iomete.com-managed" = "true"
    "iomete.com-terraform" = "true"
    "version" = "1.0"
  }
     node_labels = {
        "k8s.iomete.com/node-purpose" = "r6g.large"
    }
  
  
  depends_on = [azurerm_kubernetes_cluster.main]

 }
