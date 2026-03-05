resource "azurerm_resource_group" "rg" {
  name     = "rsgyelpaz"
  location = "East US"
}

# Storage Account que depende de rsgyelpaz
resource "azurerm_storage_account" "stgyelpaz" {
  name                     = var.storage_account_name         
  resource_group_name      = azurerm_resource_group.rg.name 
  location                 = azurerm_resource_group.rg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

}