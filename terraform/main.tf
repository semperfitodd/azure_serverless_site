resource "azurerm_resource_group" "this" {
  name     = var.project
  location = var.location
}