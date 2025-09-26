resource "azurerm_container_group" "prestashop_cg" {
  name                = "${var.project_name}-${var.environment}-rg"
  location            = var.location
  resource_group_name = var.resource_group_name
  ip_address_type     = "Public"
  dns_name_label      = "${var.dns_name_label}-${var.environment}"
  os_type             = "Linux"
  container {
    name   = "prestashop"
    image  = "prestashop/prestashop:8.1-apache"
    cpu    = var.cpu
    memory = var.memory

    ports {
      port     = 80
      protocol = "TCP"
    }

    environment_variables = {
      # Base de données
      DB_SERVER = var.db_server
      DB_NAME   = var.db_name
      DB_USER   = var.db_user
      DB_PORT   = "3306"
      # PrestaShop configuration
      PS_DOMAIN         = "${var.dns_name_label}-${var.environment}.${var.location}.taylerShift.com"
      PS_FOLDER_INSTALL = "install"
      PS_FOLDER_ADMIN   = "admin"
      PS_INSTALL_AUTO   = "1"
      # Mode développement
      PS_DEMO_MODE  = var.environment == "dev" ? "1" : "0"
      PS_DEV_MODE   = var.environment == "dev" ? "1" : "0"
      PS_ENABLE_SSL = "0"
      # Configuration locale
      PS_LANGUAGE = "fr"
      PS_COUNTRY  = "FR"
      PS_TIMEZONE = "Europe/Paris"
      PS_ERASE_DB = var.environment == "dev" ? "1" : "0"
    }

    secure_environment_variables = {
      DB_PASSWD    = var.db_password
      ADMIN_PASSWD = var.admin_password
    }

    # NOUVEAU: Liveness probe pour vérifier que le container démarre correctement
    liveness_probe {
      http_get {
        path   = "/"
        port   = 80
        scheme = "Http"
      }
      initial_delay_seconds = 30
      period_seconds        = 30
      timeout_seconds       = 10
      failure_threshold     = 3
    }
    # NOUVEAU: Readiness probe pour vérifier que le container est prêt à recevoir du trafic
    readiness_probe {
      http_get {
        path   = "/"
        port   = 80
        scheme = "Http"
      }
      initial_delay_seconds = 30
      period_seconds        = 30
      timeout_seconds       = 10
      failure_threshold     = 3
    }
  }

  restart_policy = "Always"

  # NOUVEAU: Configuration DNS pour résolution de noms
  dns_config {
    nameservers = ["8.8.8.8", "8.8.4.4"]
  }
  tags = {
    Environment = var.environment
  }
}
# Load Balancer Backend Pool
resource "azurerm_lb_backend_address_pool" "prestashop" {
  loadbalancer_id = var.load_balancer_id
  name            = "prestashop-backend-pool"
}

# NOUVEAU: Associer les containers au backend pool
resource "azurerm_lb_backend_address_pool_address" "prestashop" {
  count                   = var.instance_count
  name                    = "prestashop-${count.index + 1}"
  backend_address_pool_id = azurerm_lb_backend_address_pool.prestashop.id
  virtual_network_id      = var.virtual_network_id
  ip_address              = azurerm_container_group.prestashop_cg[count.index].ip_address
}

# Load Balancer Rule
resource "azurerm_lb_rule" "http" {
  loadbalancer_id                = var.load_balancer_id
  name                           = "HTTP"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "PublicIPAddress"
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.prestashop.id]
  probe_id                       = azurerm_lb_probe.http.id
}

# Health Probe
resource "azurerm_lb_probe" "http" {
  loadbalancer_id     = var.load_balancer_id
  name                = "http-probe"
  port                = 80
  protocol            = "Http"
  request_path        = "/"
  interval_in_seconds = 15
  number_of_probes    = 2
}
