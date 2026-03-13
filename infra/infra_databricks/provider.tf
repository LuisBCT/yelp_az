terraform {
  required_providers {
    databricks = {
      source  = "databricks/databricks"
      version = "~> 1.0"
    }
  }

  backend "azurerm" {
    resource_group_name  = "rg-terraform-state"
    storage_account_name = "stterraformstateyelp"
    container_name       = "tfstate"
    key                  = "databricks.tfstate"
  }
}

# Provider para el ACCOUNT de Databricks
provider "databricks" {
  alias = "accounts"

  host       = "https://accounts.azuredatabricks.net"
  account_id = var.account_id

  azure_client_id     = var.client_id
  azure_client_secret = var.client_secret
  azure_tenant_id     = var.tenant_id
}

# Provider para el WORKSPACE de Databricks
provider "databricks" {
  host = data.terraform_remote_state.infra_az.outputs.databricks_workspace_url

  azure_client_id     = var.client_id
  azure_client_secret = var.client_secret
  azure_tenant_id     = var.tenant_id
}
