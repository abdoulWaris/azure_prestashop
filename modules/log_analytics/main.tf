resource "azurerm_log_analytics_workspace" "prestashop_logs_analytics" {
  name                = "${var.project_name}-logs-${var.environment}"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 30

  tags = {
    Environment = var.environment
  }
}