
variable "storage_account_name" {
  type        = string
  description = "The name of the storage account"
}
  
variable "resource_group_name" {
  type        = string
  description = "The name of the resource group"
}

variable "location" {
  type        = string
  description = "The location of the resource group"
}

variable "container_name" {
  type        = string
  description = "The name of the container for lakehouse"
}
 

variable "storage_account_id" {
  type        = string
  description = "The id of the storage account"
}
  