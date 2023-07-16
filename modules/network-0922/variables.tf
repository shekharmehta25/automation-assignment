variable "rg-name" {
    type = string
}
variable "location" {
    type = string
}
variable "vnet-name" {
  type = string
}
variable "vnet-space" {
 default = ["10.0.0.0/16"]

}
variable "subnet-name1" {
  type = string 
}


variable "subnet1-address-space" {
  default = ["10.0.1.0/24"]
}

variable "security-group1" {
  type = string 
}