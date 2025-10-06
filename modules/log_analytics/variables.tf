variable "project_name" {
  description = "The name of the project to which the Log Analytics workspace belongs."
  type        = string
}
variable "environment" {
  description = "The environment in which the Log Analytics workspace is deployed."
  type        = string
}
variable "location" {
  description = "The Azure region where the Log Analytics workspace is located."
  type        = string
}
variable "resource_group_name" {
  description = "The name of the resource group in which the Log Analytics workspace is deployed."
  type        = string
}

variable "retention_in_days" {
  description = "The number of days to retain data in the Log Analytics workspace."
  type        = number  
}
