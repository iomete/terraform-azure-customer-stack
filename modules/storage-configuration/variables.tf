  
variable "resource_group_name" {
  type        = string
  description = "The name of the resource group"
}

variable "location" {
  type        = string
  description = "The location of the resource group"
}

variable "cluster_name" {
  type        = string
  description = "The name of the dluster(data-plane)"
}
 

variable "storage_account_name" {
  type        = string
  description = "The name of existing storage account"
  default = "empty"
}
   