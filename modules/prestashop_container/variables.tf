variable "project_name" {
  description = "Nom du projet"
  type        = string
}

variable "resource_group_name" {
  description = "Nom du groupe de ressources"
  type        = string
}

variable "location" {
  description = "Région Azure"
  type        = string
}

variable "environment" {
  description = "Environnement"
  type        = string
}

variable "prestashop_image" {
  description = "Image Docker PrestaShop"
  type        = string
  default     = "prestashop/prestashop:8.1-apache"
}

variable "cpu" {
  description = "CPU alloué"
  type        = string
  default     = "1"
}

variable "memory" {
  description = "Mémoire allouée en GB"
  type        = string
  default     = "2"
}

variable "dns_name_label" {
  description = "Label DNS unique"
  type        = string
}

variable "db_server" {
  description = "Serveur de base de données"
  type        = string
}

variable "db_name" {
  description = "Nom de la base de données"
  type        = string
}

variable "db_user" {
  description = "Utilisateur de la base de données"
  type        = string
}

variable "db_password" {
  description = "Mot de passe de la base de données"
  type        = string
  sensitive   = true
}

variable "storage_account_name" {
  description = "Nom du compte de stockage"
  type        = string
}

variable "storage_account_key" {
  description = "Clé du compte de stockage"
  type        = string
  sensitive   = true
}

variable "storage_share_name" {
  description = "Nom du partage de stockage"
  type        = string
}

variable "admin_email" {
  description = "Email administrateur PrestaShop"
  type        = string
  default     = "admin@prestashop.local"
}

variable "admin_password" {
  description = "Mot de passe administrateur PrestaShop"
  type        = string
  default     = "Admin123!"
}
variable "virtual_network_id" {
  description = "Virtual Network ID"
  type        = string
}
variable "load_balancer_id" {
  description = "ID du Load Balancer pour lier le container"
  type        = string  
}
variable "instance_count" {
  description = "Number of PrestaShop instances"
  type        = number
  default     = 1  # Pour dev, on commence par 1
}
variable "auto_install" {
  description = "Auto-install PrestaShop (1 to enable, 0 to disable)"
  type        = string
}