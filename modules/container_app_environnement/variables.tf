variable "project_name" {
  description = "The name of the project to which the Container App Environment belongs."
  type        = string
}
variable "environment" {
  description = "The environment in which the Container App Environment is deployed."
  type        = string
}
variable "location" {
  description = "The Azure region where the Container App Environment is located."
  type        = string
}
variable "resource_group_name" {
  description = "The name of the resource group in which the Container App Environment is deployed."
  type        = string
}
variable "subnet_id" {
  description = "The ID of the subnet in which the Container App Environment is deployed."
  type        = string
}
variable "log_analytics_workspace_id" {
  description = "The ID of the Log Analytics workspace to which the Container App Environment is linked."
  type        = string
}
variable "cpu" {
  description = "The CPU allocation for the Container App Environment."
  type        = string
  default     = "0.5"
  
}
variable "memory" {
  description = "The memory allocation for the Container App Environment."
  type        = string
  default     = "1.0Gi"
}
