output "latest_revision_fqdn" {
    description = "FQDN of the latest revision of the PrestaShop container app"
  value = azurerm_container_app.prestashop.latest_revision_fqdn
}