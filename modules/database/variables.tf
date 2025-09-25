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

variable "admin_username" {
  description = "Nom d'utilisateur administrateur"
  type        = string
  default     = "prestashopadmin"
}

variable "admin_password" {
  description = "Mot de passe administrateur"
  type        = string
  sensitive   = true
}

variable "sku_name" {
  description = "SKU pour le serveur MySQL"
  type        = string
  default     = "B_Standard_B1ms"
}

variable "storage_gb" {
  description = "Taille du stockage en GB"
  type        = number
  default     = 20
}

variable "backup_retention_days" {
  description = "Nombre de jours de rétention des sauvegardes"
  type        = number
  default     = 7
}

variable "database_name" {
  description = "Nom de la base de données"
  type        = string
  default     = "prestashop"
}