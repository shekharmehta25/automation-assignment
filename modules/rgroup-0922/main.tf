resource "azurerm_resource_group" "rgroup" {
  name     = var.rg-name
  location = var.location
  tags     = var.common_tags
}