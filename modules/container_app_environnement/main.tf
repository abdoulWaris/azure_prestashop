resource "azurerm_container_app_environment" "Container_app_env" {
  name                       = "${var.project_name}-env-${var.environment}"
  location                   = var.location
  resource_group_name        = var.resource_group_name
  infrastructure_subnet_id   = var.subnet_id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  tags = {
    Environment = var.environment
  }
}