data "terraform_remote_state" "infra_az" {
  backend = "azurerm"

  config = {
    resource_group_name  = "rg-terraform-state"
    storage_account_name = "stterraformstateyelp"
    container_name       = "tfstate"
    key                  = "azure.tfstate"
  }
}