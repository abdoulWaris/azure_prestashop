output "container_app_environment_id" {
  description = "ID of the Container App Environment"
  value       = module.container_app_environment.container_app_env_id
}
output "application_url" {
  description = "URL to access the PrestaShop application"
  value       = "https://${module.container_app.latest_revision_fqdn}"
}

output "admin_url" {
  description = "URL to access the PrestaShop admin panel"
  value       = "https://${module.container_app.latest_revision_fqdn}/admin"
}
output "prestashop_fqdn" {
  description = "FQDN of the PrestaShop Container App"
  value       = module.container_app.latest_revision_fqdn
}
output "admin_email_credentials" {
  description = "Identifiants administrateur"
  value = var.admin_email
  sensitive   = true
  }
  
output "database_info" {
  description = "Database connection information"
  value = {
    server_name = module.database.mysql_server_name
    database_name = module.database.database_name
    fqdn = module.database.mysql_fqdn
  }
  sensitive = true
}
output "database_server_name_info" {
  description = "Database server name information"
  value =  module.database.mysql_server_name
}
output "database_name_info" {
  description = "Database connection information"
  value =  module.database.database_name
}
output "database_fqdn_info" {
  description = "Database FQDN information"
  value =  module.database.mysql_fqdn
  sensitive = true
}
output "resource_group_name" {
  description = "Nom du groupe de ressources"
  value       = module.resource_group.resource_group_name
}