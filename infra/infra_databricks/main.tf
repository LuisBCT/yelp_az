resource "databricks_metastore" "uc" {
  provider = databricks.accounts
  name         = "first_metastore"
  storage_root = "abfss://newmetastore@stgfull1.dfs.core.windows.net/"
  region       = "eastus"
}

resource "databricks_metastore_assignment" "workspace" {
  provider = databricks.accounts
  workspace_id = data.terraform_remote_state.infra_az.outputs.workspace_id
  metastore_id = databricks_metastore.uc.id
}

resource "databricks_storage_credential" "yelpaz_cred" {
  name = "yelpaz-storage-cred"

  azure_managed_identity {
    access_connector_id = data.terraform_remote_state.infra_az.outputs.access_connector_id
  }
}

## data "databricks_current_user" "me" {} 
## output "who_am_i" { value = data.databricks_current_user.me.user_name }

## resource "databricks_service_principal" "sp" {
##  application_id = var.client_id
## }
