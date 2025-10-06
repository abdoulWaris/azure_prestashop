variable "project_name" {
  description = "Nom du projet"
  type        = string
  default     = "taylorShip-prestashop"
}
variable "environment" {
  description = "Environnement"
  type        = string
  default     = "dev"
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be one of: dev, staging, prod."
  }
}
variable "location" {
  description = "Région Azure"
  type        = string
  default     = "France Central"
}

variable "dns_name_label" {
  description = "Label DNS unique"
  type        = string
}
# les variables de connexion à mettre de le tfvars
variable "mysql_user_username" {
  description = "MySQL username"
  type        = string
 
}

variable "mysql_user_password" {
  description = "MySQL password"
  type        = string
  sensitive   = true
  validation {
    condition     = length(var.mysql_user_password) >= 8
    error_message = "Admin password must be at least 8 characters long."
  }
}

variable "admin_email" {
  description = "PrestaShop Admin email"
  type        = string
  sensitive = true
  validation {
    condition     = can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", var.admin_email))
    error_message = "Admin email must be a valid email address."
  }
}

variable "admin_password" {
  description = "Mot de passe administrateur PrestaShop"
  type        = string
  sensitive   = true
    validation {
        condition     = length(var.admin_password) >= 8
        error_message = "Admin password must be at least 8 characters long."
    }
}
variable "retention_in_days" {
  description = "The number of days to retain data in the Log Analytics workspace."
  type        = number
  default     = 7
}
variable "storage_gb" {
  description = "Storage size in GB"
  type        = number
  default     = 10
}
variable "sku_name" {
  description = "SKU for MySQL server"
  type        = string
  default     = "B_Standard_B1ms"
  
}
#######################################################################################