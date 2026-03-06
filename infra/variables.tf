variable "storage_account_name" {
  description = "Nombre único del Storage Account"
  type = string
  default = "styelpaz01" 
}

# Containers staging, bronze, silver, gold
variable "container_staging_name" {
  type = string
  description = "Nombre del container staging"
  default = "staging"
}
variable "container_bronze_name" {
  type = string
  description = "Nombre del container bronze"
  default = "bronze"
}
variable "container_silver_name" {
  type = string
  description = "Nombre del container silver"
  default = "silver"
}
variable "container_gold_name" {
  type = string
  description = "Nombre del container gold"
  default = "gold"
}

# Variables para backend
variable "backend_storage_account_name" {
  type = string
  description = "Nombre del Storage Account para el backend de Terraform"
  default = "tfstateyelpaz" 
}

variable "backend_container_name" {
  type = string
  description = "Container dentro del Storage Account para el state"
  default = "tfstate"
}

### DATBRICKS VARIABLES

variable "databricks_workspace_name" {
  type = string
  description = "Nombre del workspace de databricks"
  default = "ws-yelpaz"
}

variable "databricks_access_connector_name" {
  type = string
  description = "Nombre access_connector de databricks para UC"
  default = "ac-yelpaz-databricks"
}
variable "container_metastore_yelpaz_name" {
  type = string
  description = "Nombre del container para el metastore"
  default = "metastore_yelpaz"
}