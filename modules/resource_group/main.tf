resource "azurerm_resource_group" "resource_group" {
  name     = "${var.name}-${var.environment}-rg"
  location = var.location

  tags = {
    Name        = "${var.name}-${var.environment}-rg"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }
}