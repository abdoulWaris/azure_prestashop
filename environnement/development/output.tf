output "container_app_environment_id" {
  description = "ID of the Container App Environment"
  value       = azurerm_container_app_environment.main.id
}
output "application_url" {
  description = "URL to access the PrestaShop application"
  value       = "https://${azurerm_container_app.prestashop.latest_revision_fqdn}"
}

output "admin_url" {
  description = "URL to access the PrestaShop admin panel"
  value       = "https://${azurerm_container_app.prestashop.latest_revision_fqdn}/admin"
}
output "prestashop_fqdn" {
  description = "FQDN of the PrestaShop Container App"
  value       = azurerm_container_app.prestashop.latest_revision_fqdn
}
output "admin_credentials" {
  description = "Identifiants administrateur"
  value = {
    email    = var.admin_email
    password = var.admin_password
  }
  sensitive = true
}
output "database_info_email" {
  description = "Database connection information"
  value = var.admin_email
}
output "database_info" {
  description = "Database connection information"
  value = {
    server_name = module.database.mysql_server_name
    database_name = module.database.database_name
    fqdn = module.database.mysql_fqdn
  }
  sensitive = false
}

output "resource_group_name" {
  description = "Nom du groupe de ressources"
  value       = module.resource_group.resource_group_name
}