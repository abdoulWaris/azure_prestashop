# Module Resource Group
module "resource_group" {
  source = "../../modules/resource_group"
  
  name        = var.project_name
  location    = var.location
  environment = var.environment
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
module "mysql" {
  source = "../../modules/database"

  project_name        = var.project_name
  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.resource_group_location
  environment         = var.environment
  admin_username      = var.mysql_admin_username
  admin_password      = var.mysql_admin_password
  sku_name            = "B_Standard_B1ms"
  storage_gb          = 20
}

# Module Container Instance
module "container" {
  source = "../../modules/prestashop_container"
  
  project_name = var.project_name
  resource_group_name = module.resource_group.resource_group_name
  location           = module.resource_group.resource_group_location
  environment        = var.environment
  dns_name_label     = var.dns_name_label
  cpu               = "0.5"
  memory            = "1.5"
  db_server         = module.mysql.server_fqdn
  db_name           = module.mysql.database_name
  db_user           = module.mysql.admin_username
  db_password       = var.mysql_admin_password
  storage_account_name = module.storage.account_name
  storage_account_key  = module.storage.primary_access_key
  storage_share_name   = module.storage.share_name
  admin_email       = var.admin_email
  admin_password    = var.admin_password
  depends_on = [module.mysql]
}