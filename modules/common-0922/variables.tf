variable "rg-name" {
    type = string
}
variable "location" {
    type = string
}
variable "la_name" {
    type = string
}
variable "storage_account_name" {
}
variable "recovery_services_vault" {
  type = map(string)
  default = {
    vault_name = "n0922-rv"
    vault_sku  = "Standard"
  }
}

variable "subnet_id" {

}

variable "common_tags" {
  type    = map(string)
}