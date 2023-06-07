# variable "create_resource_group" {
#   type     = bool
#   default  = true
#   nullable = false
# }
# variable "resource_group_name" {
#   type        = string
#   description = "Resource group name"

# }
# variable "node_resource_group_name" {
#   type        = string
#   description = "Nodes (virtual machines) resource group name"
# }

variable "location" {
  description = "AKS region where cluster will be created"
}

variable "cluster_id" {
  description = "Cluster id from IOMETE. This should match the cluster id in IOMETE"
  type        = string
}

variable "orchestrator_version" {
  description = "AKS kubernetes version"
  type        = string
  default     = "1.24.9"
}

variable "exec_max_count" {
  type        = number
  default     = 200
  description = "Max. Node count for for lakehosue executer"
}

variable "exec_min_count" {
  type        = number
  default     = 1
  description = "Min. Node count for for lakehosue exec"

}

variable "driver_max_count" {
  type        = number
  default     = 3
  description = "Maximum Node count for for driver"
}

variable "driver_min_count" {
  type        = number
  default     = 1
  description = "Maximum Node count for for driver"

}

variable "system_vm_size" {
  type        = string
  default     = "Standard_D4as_v5"
  description = "Node size for for system"

}
variable "sku_tier" {
  type        = string
  default     = "Free"
  description = "Node size for min."

}

variable "container_name" {
  type        = string
  description = "Container name for lakehouse"
}

variable "storage_account_name" {
  type        = string
  description = "Storage account name"

}

