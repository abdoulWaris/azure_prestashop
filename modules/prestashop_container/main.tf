resource "azurerm_container_group" "prestashop_cg" {
  name                = "${var.project_name}-${var.environment}-cg"
  location            = var.location
  resource_group_name = var.resource_group_name
  ip_address_type     = "Public"
  dns_name_label      = "${var.dns_name_label}-${var.environment}"
  os_type             = "Linux"

  container {
    name   = "prestashop"
    image  = var.prestashop_image
    cpu    = var.cpu
    memory = var.memory

    ports {
      port     = 80
      protocol = "TCP"
    }

    environment_variables = {
      DB_SERVER         = var.db_server
      DB_NAME          = var.db_name
      DB_USER          = var.db_user
      DB_PORT          = "3306"

      # PrestaShop configuration
      PS_DOMAIN        = "${var.dns_name_label}-${var.environment}.${var.location}.taylerShift.io"
      PS_FOLDER_INSTALL = "install"
      PS_FOLDER_ADMIN   = "admin"
      PS_INSTALL_AUTO   = "1"
      # Mode développement
      PS_DEMO_MODE = var.environment == "dev" ? "1" : "0"
      PS_DEV_MODE = var.environment == "dev" ? "1" : "0"
      PS_ENABLE_SSL = "0"
      # Configuration locale
      PS_LANGUAGE = "fr"
      PS_COUNTRY = "FR"
      PS_TIMEZONE = "Europe/Paris"
      PS_ERASE_DB       = var.environment == "dev" ? "1" : "0"
      ADMIN_MAIL        = var.admin_email
    }

    secure_environment_variables = {
       DB_PASSWD = var.db_password
      # Ces variables seront utilisées lors de l'installation manuelle
      ADMIN_MAIL = var.admin_email
      ADMIN_PASSWD = var.admin_password
    }

    volume {
      name                 = "prestashop-files"
      mount_path          = "/var/www/html"
      read_only           = false
      storage_account_name = var.storage_account_name
      storage_account_key  = var.storage_account_key
      share_name          = var.storage_share_name
    }
  }

  tags =  {
    Environment = var.environment
  }
}