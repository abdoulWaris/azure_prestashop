resource "azurerm_container_app" "prestashop" {
  name                         = "${var.project_name}-prestashop-${var.environment}"
  container_app_environment_id = var.container_app_environment_id
  resource_group_name          = var.resource_group_name
  revision_mode                = "Single"

  template {
    min_replicas = 1
    max_replicas = 1

    container {
      name   = "prestashop"
      image  = var.prestashop_image
      cpu    = "0.75"
      memory = "1.5Gi"

      env {
        name        = "DB_SERVER"
        secret_name = "db-server"
      }
      env {
        name        = "DB_NAME"
        secret_name = "db-name"
      }
      env {
        name        = "DB_USER"
        secret_name = "db-user"
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
      volume_mounts {
        name = "prestashop-files"
        path = "/var/www/html"
      }
    }
    volume {
      name         = "prestashop-files"
      storage_type = "AzureFile"
      storage_name = var.storage_account_name
    }

  }

  ingress {
    external_enabled = true
    target_port      = 80

    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }

  # Secrets injectés depuis variables
  secret {
    name  = "db-password"
    value = var.db_password
  }
  secret {
    name  = "admin-email"
    value = var.admin_email
  }
  secret {
    name  = "admin-password"
    value = var.admin_password
  }
  secret {
    name  = "db-server"
    value = var.db_server
  }
  secret {
    name  = "db-user"
    value = var.db_user
  }
  secret {
    name  = "db-name"
    value = var.db_name
  }

  depends_on = [var.database]
  tags = {
    Environment = var.environment
  }
}
