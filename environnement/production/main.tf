# Module Resource Group
module "resource_group" {
  source = "../../modules/resource_group"

  name        = var.project_name
  location    = var.location
  environment = var.environment
}
# Module Networking
module "networking" {
  source                  = "../../modules/networking"
  project_name            = var.project_name
  resource_group_name     = module.resource_group.resource_group_name
  resource_group_location = module.resource_group.resource_group_location
  environment             = var.environment
}
# Module Storage Account
module "storage" {
  source = "../../modules/storage"

  project_name        = var.project_name
  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.resource_group_location
  environment         = var.environment
  share_quota         = 20
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
# PrestaShop Application
# Info: lors d'un second deploiement modiifer PS_AUTO_INSTALL à 1
module "prestashop" {
  source               = "../../modules/prestashop_container"
  project_name         = var.project_name
  environment          = var.environment
  resource_group_name  = module.resource_group.resource_group_name
  location             = module.resource_group.resource_group_location
  auto_install         = var.auto_install
  load_balancer_id     = module.networking.load_balancer_id
  instance_count       = "1"
  db_server            = module.database.mysql_fqdn
  db_name              = "prestashop"
  db_user              = module.database.mysql_admin_username
  db_password          = var.db_password
  admin_email          = var.admin_email
  admin_password       = var.admin_password
  virtual_network_id   = module.networking.virtual_network_id
  storage_share_name   = module.storage.storage_share_name
  storage_account_key  = module.storage.storage_account_key
  storage_account_name = module.storage.storage_account_name
  dns_name_label       = module.networking.load_balancer_ip
}
