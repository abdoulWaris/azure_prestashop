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
variable "container_app_environment_id" {
    description = "The ID of the Container App Environment to which the Log Analytics workspace is linked."
    type        = string
}
variable "prestashop_image" {
    description = "The Docker image for the PrestaShop application."
    type        = string
    default     = "prestashop/prestashop:8.1-apache"
}
variable "db_password" {
    description = "The password for the PrestaShop database user."
    type        = string
    sensitive   = true
}
variable "db_server" {
    description = "The hostname or IP address of the PrestaShop database server."
    type        = string
}
variable "db_name" {
    description = "The name of the PrestaShop database."
    type        = string
}
variable "db_user" {
    description = "The username for the PrestaShop database."
    type        = string
}
variable "admin_email" {
    description = "The email address for the PrestaShop admin user."
    type        = string
}
variable "admin_password" {
    description = "The password for the PrestaShop admin user."
    type        = string
    sensitive   = true
}
variable "storage_account_name" {
    description = "The name of the Azure Storage Account for PrestaShop."
    type        = string
}
variable "database"{
  description = "Database module"
  type        = any
}
variable "cpu" {
  description = "The number of CPU cores for the PrestaShop container."
  type        = number
  default     = 0.75
}
variable "memory" {
  description = "The amount of memory (in GB) for the PrestaShop container."
  type        = number
  default     = 1.5
}