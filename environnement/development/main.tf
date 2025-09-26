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
module "prestashop_logs_analytics" {
  source = "../../modules/log_analytics"
  project_name        = var.project_name
  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.resource_group_location
  environment         = var.environment
}
# Container App Environment
module "container_app_environment" {
  source = "../../modules/container_app_environnement"
  project_name                = var.project_name
  resource_group_name         = module.resource_group.resource_group_name
  location                    = module.resource_group.resource_group_location
  environment                 = var.environment
  subnet_id                   = module.networking.container_apps_subnet_id
  log_analytics_workspace_id  = module.prestashop_logs_analytics.id
}
# Container App 
module "container_app" {
  source = "../../modules/prestashop"
  project_name                 = var.project_name
  resource_group_name          = module.resource_group.resource_group_name
  location                     = module.resource_group.resource_group_location
  environment                  = var.environment
  container_app_environment_id = module.container_app_environment.Container_app_env_id
  prestashop_image             = "prestashop/prestashop:8.1-apache"
  db_password                  = var.mysql_user_password
  db_server                    = module.database.server_fqdn
  db_name                      = module.database.mysql_database_name
  db_user                      = module.database.mysql_admin_username
  admin_email                  = var.admin_email
  admin_password               = var.admin_password
  storage_account_name         = module.storage.storage_account_name
  database                     = module.database
  
}