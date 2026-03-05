resource "azurerm_resource_group" "rg" {
  name     = "rsgyelpaz"
  location = "East US"
}

# Storage Account que depende de rsgyelpaz
resource "azurerm_storage_account" "stgyelpaz" {
  name = var.storage_account_name         
  resource_group_name = azurerm_resource_group.rg.name 
  location = azurerm_resource_group.rg.location
  account_tier = "Standard"
  account_replication_type = "LRS"
}

# Containers stg, bronze, silver, gold
resource "azurerm_storage_container" "ystg"{
  name = var.container_staging_name
  storage_account_name = azurerm_storage_account.stgyelpaz.name
  container_access_type = "Container"
}
resource "azurerm_storage_container" "ybr"{
  name = var.container_bronze_name
  storage_account_name = azurerm_storage_account.stgyelpaz.name
  container_access_type = "Container"
}
resource "azurerm_storage_container" "ysv"{
  name = var.container_silver_name
  storage_account_name = azurerm_storage_account.stgyelpaz.name
  container_access_type = "Container"
}
resource "azurerm_storage_container" "ygd"{
  name = var.container_gold_name
  storage_account_name = azurerm_storage_account.stgyelpaz.name
  container_access_type = "Container"
}

# Storage Account para el tfstate
resource "azurerm_storage_account" "tfstate" {
  name = var.backend_storage_account_name
  resource_group_name = azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
  account_tier = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "tfstate" {
  name = var.backend_container_name
  storage_account_name = azurerm_storage_account.tfstate.name
  container_access_type = "private"
}