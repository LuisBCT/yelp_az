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