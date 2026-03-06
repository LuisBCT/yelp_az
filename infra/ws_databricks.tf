resource "azurerm_databricks_workspace" "ws_yelpaz" {
  name                = var.databricks_workspace_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "premium"
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