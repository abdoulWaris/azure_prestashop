resource "azurerm_mysql_flexible_server" "prestashop_server" {
  name                   = "${var.project_name}-${var.environment}-mysql"
  resource_group_name    = var.resource_group_name
  location              = var.location
  administrator_login    = var.admin_username
  administrator_password = var.admin_password
  backup_retention_days  = var.backup_retention_days
  sku_name              = var.sku_name
  version               = "8.0.21"

  storage {
    size_gb = var.storage_gb
    iops    = var.environment == "prod" ? 400 : 360
  }

  tags = {
    Environment = var.environment
  }
}

# Configuration MySQL pour PrestaShop
resource "azurerm_mysql_flexible_server_configuration" "sql_mode" {
  name                = "sql_mode"
  resource_group_name = var.resource_group_name
  server_name         = azurerm_mysql_flexible_server.prestashop_server.name
  value               = "STRICT_TRANS_TABLES,NO_ZERO_DATE,NO_ZERO_IN_DATE,ERROR_FOR_DIVISION_BY_ZERO"
}

# Désactiver SSL requirement pour dev (plus facile pour debug)
resource "azurerm_mysql_flexible_server_configuration" "require_secure_transport" {
  name                = "require_secure_transport"
  resource_group_name = var.resource_group_name
  server_name         = azurerm_mysql_flexible_server.prestashop_server.name
  value               = "OFF"  # SSL désactivé pour dev
}

resource "azurerm_mysql_flexible_database" "prestashop_db" {
  name                = "${var.project_name}-${var.environment}-db"
  resource_group_name = var.resource_group_name
  server_name         = azurerm_mysql_flexible_server.prestashop_server.name
  charset             = "utf8mb4"
  collation           = "utf8mb4_unicode_ci"
}

resource "azurerm_mysql_flexible_server_firewall_rule" "allow_azure_access" {
  name                = "${var.project_name}-${var.environment}-AllowAccess"
  resource_group_name = var.resource_group_name
  server_name         = azurerm_mysql_flexible_server.prestashop_server.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "0.0.0.0"
}

resource "azurerm_mysql_flexible_server_firewall_rule" "dev_test_allow_all" {
  count               = var.environment == "dev" ? 1 : 0
  name                = "${var.project_name}-${var.environment}-AllowAll"
  resource_group_name = var.resource_group_name
  server_name         = azurerm_mysql_flexible_server.prestashop_server.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "255.255.255.255"
}