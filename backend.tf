terraform {
  backend "azurerm" {
    resource_group_name  = "tfstaten01580922RG"
    storage_account_name = "tfstaten01580922sa"
    container_name       = "tfstatefiles"
    key                  = "terraform.tfstate"
  }
}