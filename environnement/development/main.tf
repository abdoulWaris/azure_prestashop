# Module Resource Group
module "resource_group" {
  source = "../../modules/resource_group"
  
  name        = var.project_name
  location    = var.location
  environment = var.environment
}
# Module Networking
module "networking" {
  source = "../../modules/networking"
  project_name         = var.project_name
  resource_group_name  = module.resource_group.resource_group_name
  resource_group_location = module.resource_group.resource_group_location
  environment          = var.environment
}
# Module Storage Account
module "storage" {
  source = "../../modules/storage"
  
  project_name = var.project_name
  resource_group_name = module.resource_group.resource_group_name
  location           = module.resource_group.resource_group_location
  environment        = var.environment
  share_quota        = 20
}
# Module PrestaShop Container
module "database" {
  source = "../../modules/database"

  project_name        = var.project_name
  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.resource_group_location
  environment         = var.environment
  admin_username      = var.mysql_user_username
  admin_password      = var.mysql_user_password
  sku_name            = "B_Standard_B1ms"
  storage_gb          = 20
}
# Log Analytics Workspace (requis pour Container Apps)
resource "azurerm_log_analytics_workspace" "main" {
  name                = "${var.project_name}-logs-${var.environment}"
  location            = var.location
  resource_group_name = module.resource_group.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  tags = {
    Environment = var.environment
  }
}
# Container App Environment
resource "azurerm_container_app_environment" "main" {
  name                       = "${var.project_name}-env-${var.environment}"
  location                   = var.location
  resource_group_name        = module.resource_group.resource_group_name
  infrastructure_subnet_id   = module.networking.container_apps_subnet_id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id
  tags = {
    Environment = var.environment
  }
}
# Module Container Instance
# PrestaShop Container App
resource "azurerm_container_app" "prestashop" {
  name                         = "${var.project_name}-prestashop-${var.environment}"
  container_app_environment_id = azurerm_container_app_environment.main.id
  resource_group_name          = module.resource_group.resource_group_name
  revision_mode               = "Single"

  template {
    min_replicas = 1
    max_replicas = 1

    container {
      name   = "prestashop"
      image  = "prestashop/prestashop:8.1-apache"
      cpu    = "0.75"
      memory = "1.5Gi"

      env {
        name  = "DB_SERVER"
        value = module.database.server_fqdn
      }
      
      env {
        name  = "DB_NAME"
        value = "prestashop"
      }
      
      env {
        name  = "DB_USER"
        value = module.database.mysql_admin_username
      }
      
      env {
        name        = "DB_PASSWD"
        secret_name = "db-password"
      }
      
      env {
        name  = "DB_USE_SSL"
        value = "0"
      }
      
      env {
        name  = "PS_INSTALL_AUTO"
        value = "0"
      }
      
      env {
        name  = "PS_DEV_MODE"
        value = var.environment == "dev" ? "1" : "0"
      }
      
      env {
        name  = "PS_ENABLE_SSL"
        value = "0"
      }

      env {
        name        = "ADMIN_MAIL"
        secret_name = "admin-email"
      }
      
      env {
        name        = "ADMIN_PASSWD"
        secret_name = "admin-password"
      }
    }
  }

  # Configuration du trafic entrant
  ingress {
    external_enabled = true
    target_port      = 80
    
    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }

  # Secrets
  secret {
    name  = "db-password"
    value = var.mysql_user_password
  }
  
  secret {
    name  = "admin-email"
    value = var.admin_email
  }
  
  secret {
    name  = "admin-password"
    value = var.admin_password
  }

  tags = {
    Environment = var.environment
  }
  
  depends_on = [module.database]
}