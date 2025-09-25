output "account_name" {
  description = "Nom du compte de stockage"
  value       = azurerm_storage_account.prestashop_storage.name
}

output "primary_access_key" {
  description = "Clé d'accès primaire"
  value       = azurerm_storage_account.prestashop_storage.primary_access_key
  sensitive   = true
}

output "share_name" {
  description = "Nom du partage de fichiers"
  value       = azurerm_storage_share.prestashop.name
}