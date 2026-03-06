data "terraform_remote_state" "infra_az" {
  backend = "azurerm"

  config = {
    resource_group_name  = "rsgyelpaz"
    storage_account_name = "tfstateyelpaz"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}