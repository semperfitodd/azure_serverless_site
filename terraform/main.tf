resource "azurerm_resource_group" "this" {
  name     = var.project
  location = "East US"
}