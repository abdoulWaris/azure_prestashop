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

variable "account_tier" {
  description = "Tier du compte de stockage"
  type        = string
  default     = "Standard"
}

variable "replication_type" {
  description = "Type de réplication"
  type        = string
  default     = "LRS"
}

variable "share_quota" {
  description = "Quota du partage en GB"
  type        = number
  default     = 50
}
