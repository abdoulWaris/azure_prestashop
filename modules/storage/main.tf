resource "random_string" "storage_suffix" {
  length  = 8
  special = false
  upper   = false
}

resource "azurerm_storage_account" "prestashop_storage" {
  name                     = "${var.project_name}${var.environment}${random_string.storage_suffix.result}"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = var.account_tier
  account_replication_type = var.replication_type

  tags = {
    Environment = var.environment
  }
}

resource "azurerm_storage_share" "prestashop" {
  name                 = "prestashop-files"
  storage_account_name = azurerm_storage_account.prestashop_storage.name
  quota                = var.share_quota
}
