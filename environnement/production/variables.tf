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
# les variables de connexion à mettre de le tfvars
variable "mysql_user_username" {
  description = "Nom d'utilisateur MySQL"
  type        = string
 
}

variable "mysql_user_password" {
  description = "Mot de passe MySQL"
  type        = string
  sensitive   = true
  validation {
    condition     = length(var.mysql_user_password) >= 8
    error_message = "Admin password must be at least 8 characters long."
  }
}

variable "db_password" {
  description = "Mot de passe de l'utilisateur PrestaShop pour la base de données"
  type        = string
  sensitive   = true
  validation {
    condition     = length(var.db_password) >= 8
    error_message = "Database password must be at least 8 characters long."
  }
}
variable "admin_email" {
  description = "Email de l'administrateur PrestaShop"
  type        = string
  }
variable "admin_password" {
  description = "Mot de passe de l'administrateur PrestaShop"
  type        = string
  sensitive   = true
  validation {
    condition     = length(var.admin_password) >= 8
    error_message = "Admin password must be at least 8 characters long."
  }
}
variable "auto_install" {
  description = "Auto-install PrestaShop (1 to enable, 0 to disable)"
  type        = string
  default     = "1"
}