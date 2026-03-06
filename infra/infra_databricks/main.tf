resource "databricks_metastore" "uc" {
  name         = "yelpaz-metastore"
  storage_root = "abfss://metastoreyelpaz@styelpaz01.dfs.core.windows.net/"
  region       = "eastus"
}

resource "databricks_metastore_assignment" "this" {
  workspace_id = data.terraform_remote_state.infra_az.outputs.workspace_id
  metastore_id = databricks_metastore.uc.id
}