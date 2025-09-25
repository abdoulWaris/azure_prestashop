output "server_fqdn" {
  description = "FQDN du serveur MySQL"
  value       = azurerm_mysql_flexible_server.prestashop_server.fqdn
}

output "database_name" {
  description = "Nom de la base de données"
  value       = azurerm_mysql_flexible_database.prestashop_db.name
}

output "admin_username" {
  description = "Nom d'utilisateur administrateur"
  value       = var.admin_username
}

output "server_name" {
  description = "Nom du serveur MySQL"
  value       = azurerm_mysql_flexible_server.prestashop_server.name
}
output "server_id" {
  description = "ID du serveur MySQL"
  value       = azurerm_mysql_flexible_server.prestashop_server.id
  
}
output "mysql_admin_username" {
  description = "Administrator username for the MySQL server"
  value       = azurerm_mysql_flexible_server.prestashop_server.administrator_login
  sensitive   = true
}

output "database_connection_string" {
  description = "Database connection string for PrestaShop"
  value       = "mysql://${azurerm_mysql_flexible_server.prestashop_server.administrator_login}@${azurerm_mysql_flexible_server.prestashop_server.fqdn}:3306/${azurerm_mysql_flexible_database.prestashop_db.name}"
  sensitive   = true
}