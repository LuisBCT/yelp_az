terraform {
  required_providers {
    databricks = {
      source  = "databricks/databricks"
      version = "~> 1.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "rsgyelpaz"
    storage_account_name = "tfstateyelpaz"
    container_name       = "tfstate"
    key                  = "infra-databricks.tfstate"
  }
}

provider "databricks" {
  host = data.terraform_remote_state.infra_az.outputs.databricks_workspace_url
  azure_client_id     =  var.client_id
  azure_client_secret =  var.client_secret
  azure_tenant_id     =  var.tenant_id
}

