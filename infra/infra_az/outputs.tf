output "storage_account_id" {
  value = azurerm_storage_account.stgyelpaz.id
}

output "storage_account_primary_blob_endpoint" {
  value = azurerm_storage_account.stgyelpaz.primary_blob_endpoint
}

output "databricks_workspace_url" {
  value = azurerm_databricks_workspace.ws_yelpaz.workspace_url
}

output "workspace_id" {
  value = azurerm_databricks_workspace.ws_yelpaz.workspace_id
}

output "access_connector_id" {
  value = azurerm_databricks_access_connector.access_connector.id
}