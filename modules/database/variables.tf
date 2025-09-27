variable "project_name" {
  description = "Project name"
  type        = string
}

variable "resource_group_name" {
  description = "Resource Group name"
  type        = string
}

variable "location" {
  description = "Azure Region"
  type        = string
}

variable "environment" {
  description = "Environment"
  type        = string
}

variable "admin_username" {
  description = "Admin username for MySQL"
  type        = string
  default     = "prestashopadmin"
}

variable "admin_password" {
  description = "Admin password for MySQL"
  type        = string
  sensitive   = true
}

variable "sku_name" {
  description = "SKU for MySQL server"
  type        = string
  default     = "B_Standard_B1ms"
}

variable "storage_gb" {
  description = "Storage size in GB"
  type        = number
  default     = 20
}

variable "backup_retention_days" {
  description = "Number of backup retention days"
  type        = number
  default     = 7
}

variable "database_name" {
  description = "Database name"
  type        = string
  default     = "prestashop"
}