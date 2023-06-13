
variable "location" {
  type = string
  description = "AKS region where cluster will be created"
}
 variable "zones" {
  type        = string
  default     = "2"
  description = "AKS region where cluster and resources will be created"
}
variable "cluster_id" {
  type        = string
  description = "Cluster id from IOMETE. This should match the cluster id in IOMETE"
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
