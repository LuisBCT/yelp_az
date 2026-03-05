variable "storage_account_name" {
  description = "Nombre único del Storage Account"
  type = string
  default = "stgyelpaz01" 
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