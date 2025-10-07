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
variable "cpu" {
  description = "The number of CPU cores for the PrestaShop container."
  type        = number
  default     = 0.75
  validation {
    condition     = var.cpu > 0
    error_message = "The amount of vCPU to allocate to the container. Possible values include 0.25, 0.5, 0.75, 1.0, 1.25, 1.5, 1.75, and 2.0."
  }
  
}
variable "memory" {
  description = "The amount of memory (in GB) for the PrestaShop container."
  type        = number
  default     = 1.5
  validation {
    condition     = var.memory >= 0.5
    error_message = "The amount of memory to allocate to the container. Possible values include 0.5, 1.0, 1.5, 2.0, 2.5, 3.0, 3.5, and 4.0."
  }
  
}
#######################################################################################