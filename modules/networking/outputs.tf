output "virtual_network_id" {
  description = "ID of the virtual network"
  value       = azurerm_virtual_network.main.id
}

output "virtual_network_name" {
  description = "Name of the virtual network"
  value       = azurerm_virtual_network.main.name
}

output "container_apps_subnet_id" {
  description = "ID of the Container Apps subnet"
  value       = azurerm_subnet.container_apps.id
}

output "database_subnet_id" {
  description = "ID of the database subnet"
  value       = azurerm_subnet.database.id
}

output "private_endpoints_subnet_id" {
  description = "ID of the private endpoints subnet"
  value       = azurerm_subnet.private_endpoints.id
}

output "container_apps_nsg_id" {
  description = "ID of the Container Apps Network Security Group"
  value       = azurerm_network_security_group.container_apps.id
}

output "database_nsg_id" {
  description = "ID of the Database Network Security Group"
  value       = azurerm_network_security_group.database.id
}
