variable "rg_name" {

}
variable "location" {

}
variable "db_username" {
  
}
variable "db_pass" {
  
}
variable "db_version" {
  default = "9.5"
}

variable "common_tags" {
  type    = map(string)
}
variable "db_name" {
  type    = string
}
variable "server_name" {
  type    = string
}