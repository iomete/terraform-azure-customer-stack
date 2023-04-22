variable "create_resource_group" {
  type     = bool
  default  = true
  nullable = false
}

variable "location" {
  default = "eastus"
}

variable "cluster_id" {
  description = "Cluster id from IOMETE. This should match the cluster id in IOMETE"
  type        = string
}


variable "resource_group_name" {
  type        = string
  description = "Resource group name"
  default     = "iomete-cluster-rg"
}

variable "orchestrator_version" {
  type    = string
  default = "1.24.9"
}
variable "node_min_count" {
  type        = number
  default     = 1 #system node count
  description = "value for min. node size for lakehosue exec"

}
variable "node_max_count" {
  type        = number
  default     = 2 #system node count
  description = "value for min. node size for lakehosue exec"

}

variable "exec_max_count" {
  type        = number
  default     = 10 #if you want hotpool change this for you requirement
  description = "value for max. node size for lakehosue executer"
}

variable "exec_min_count" {
  type        = number
  default     = 1 #if you want hotpool change this for you requirement
  description = "value for min. node size for lakehosue exec"

}

variable "driver_max_count" {
  type        = number
  default     = 3 #if you want hotpool change this for you requirement
  description = "value for max. node size for driver"
}

variable "driver_min_count" {
  type        = number
  default     = 1 #if you want hotpool change this for you requirement
  description = "Node size for min. for driver"

}

variable "vm_size" {
  type        = string
  default     = "Standard_F2s_v2"
  description = "Node size for min. for driver"

}
variable "sku_tier" {
  type        = string
  default     = "Free"
  description = "Node size for min."

}

variable "node_resource_group_name" {
  type        = string
  description = "Resource group name"
  default     = "iomete-cluster-nrg"
}

 
variable "storage_account_name" {
  type        = string
  description = "Storage account name"
  default     = "iometeclusterstorageacc"
}
  
variable "serv_password" {
  type        = string
  description = "Password seervice principal"
  default     = "iomete@123"
}