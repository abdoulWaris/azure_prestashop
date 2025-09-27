output "server_fqdn" {
  description = "FQDN of MySQL server"
  value       = azurerm_mysql_flexible_server.prestashop_server.fqdn
}

output "database_name" {
  description = "Database name"
  value       = azurerm_mysql_flexible_database.prestashop_db.name
}

output "admin_username" {
  description = "Admin username for MySQL"
  value       = var.admin_username
}

output "server_name" {
  description = "MySQL server name"
  value       = azurerm_mysql_flexible_server.prestashop_server.name
}
output "server_id" {
  description = "ID of MySQL server"
  value       = azurerm_mysql_flexible_server.prestashop_server.id
  
}
output "mysql_admin_username" {
  description = "Admin username for the MySQL server"
  value       = azurerm_mysql_flexible_server.prestashop_server.administrator_login
  sensitive   = true
}

output "database_connection_string" {
  description = "Database connection string for PrestaShop"
  value       = "mysql://${azurerm_mysql_flexible_server.prestashop_server.administrator_login}@${azurerm_mysql_flexible_server.prestashop_server.fqdn}:3306/${azurerm_mysql_flexible_database.prestashop_db.name}"
  sensitive   = true
}
output "mysql_server_id" {
  description = "ID of the MySQL server"
  value       = azurerm_mysql_flexible_server.prestashop_server.id
}

output "mysql_server_name" {
  description = "Name of the MySQL server"
  value       = azurerm_mysql_flexible_server.prestashop_server.name
}

output "mysql_fqdn" {
  description = "FQDN of the MySQL server"
  value       = azurerm_mysql_flexible_server.prestashop_server
}