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
  is_hns_enabled = true
}

# Containers stg, bronze, silver, gold
resource "azurerm_storage_container" "ystg"{
  name = var.container_staging_name
  storage_account_name = azurerm_storage_account.stgyelpaz.name
  container_access_type = "container"
}
resource "azurerm_storage_container" "ybr"{
  name = var.container_bronze_name
  storage_account_name = azurerm_storage_account.stgyelpaz.name
  container_access_type = "container"
}
resource "azurerm_storage_container" "ysv"{
  name = var.container_silver_name
  storage_account_name = azurerm_storage_account.stgyelpaz.name
  container_access_type = "container"
}
resource "azurerm_storage_container" "ygd"{
  name = var.container_gold_name
  storage_account_name = azurerm_storage_account.stgyelpaz.name
  container_access_type = "container"
}


## Create Databricks resources in azure 
resource "azurerm_databricks_workspace" "ws_yelpaz" {
  name                = var.databricks_workspace_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "premium"
  custom_parameters {
    no_public_ip = false
  }
}

resource "azurerm_storage_container" "msyelpaz"{
  name = var.container_metastore_yelpaz_name
  storage_account_name = azurerm_storage_account.stgyelpaz.name
  container_access_type = "container"
}

resource "azurerm_databricks_access_connector" "access_connector" {
  name                = var.databricks_access_connector_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location

  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_role_assignment" "databricks_storage_access" {
  scope                = azurerm_storage_account.stgyelpaz.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_databricks_access_connector.access_connector.identity[0].principal_id
}