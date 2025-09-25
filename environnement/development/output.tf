output "prestashop_url" {
  description = "URL d'accès à PrestaShop"
  value       = module.container.url
}

output "prestashop_admin_url" {
  description = "URL d'administration PrestaShop"
  value       = "${module.container.url}/admin"
}

output "admin_credentials" {
  description = "Identifiants administrateur"
  value = {
    email    = var.admin_email
    password = var.admin_password
  }
  sensitive = true
}

output "database_info" {
  description = "Informations de la base de données"
  value = {
    server   = module.mysql.server_fqdn
    database = module.mysql.database_name
    username = module.mysql.admin_username
  }
}

output "resource_group_name" {
  description = "Nom du groupe de ressources"
  value       = module.resource_group.resource_group_name
}