output "fqdn" {
  description = "FQDN du container"
  value       = azurerm_container_group.prestashop_cg.fqdn
}

output "ip_address" {
  description = "Adresse IP publique"
  value       = azurerm_container_group.prestashop_cg.ip_address
}

output "url" {
  description = "URL d'accès à PrestaShop"
  value       = "http://${azurerm_container_group.prestashop_cg.fqdn}"
}