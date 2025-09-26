# Virtual Network
resource "azurerm_virtual_network" "main" {
  name                = "${var.project_name}-vnet-${var.environment}"
  address_space       = ["10.0.0.0/16"]
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  tags = {
    Environment = var.environment
  }
}

# Subnet pour Container Apps Infrastructure (SANS délégation)
resource "azurerm_subnet" "container_apps" {
  name                 = "container-apps-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.0.0/23"]
}

# Subnet pour la base de données (isolation)
resource "azurerm_subnet" "database" {
  name                 = "database-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.3.0/24"]

  service_endpoints = ["Microsoft.Sql"]
}

# Private Endpoint pour MySQL (sécurité renforcée)
resource "azurerm_subnet" "private_endpoints" {
  name                 = "private-endpoints-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.4.0/24"]
  
  private_endpoint_network_policies = "Disabled"
}

# Network Security Group pour Container Apps
resource "azurerm_network_security_group" "container_apps" {
  name                = "${var.project_name}-nsg-containerapp-${var.environment}"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "AllowHTTPS"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "AllowHTTP"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }

  tags = {
    Environment = var.environment
  }
}

# Association NSG avec le subnet Container Apps
resource "azurerm_subnet_network_security_group_association" "container_apps" {
  subnet_id                 = azurerm_subnet.container_apps.id
  network_security_group_id = azurerm_network_security_group.container_apps.id
}

# Network Security Group pour Database (plus restrictif)
resource "azurerm_network_security_group" "database" {
  name                = "${var.project_name}-db-sg-${var.environment}"
  location            = var.resource_group_location
  resource_group_name = var.resource_group_name

  security_rule {
    name                       = "AllowMySQLFromContainerApps"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3306"
    source_address_prefix      = "10.0.0.0/23"  
    destination_address_prefix = "*"
  }

  tags = {
    Environment = var.environment
  }
}

# Association NSG avec le subnet Database
resource "azurerm_subnet_network_security_group_association" "database" {
  subnet_id                 = azurerm_subnet.database.id
  network_security_group_id = azurerm_network_security_group.database.id
}