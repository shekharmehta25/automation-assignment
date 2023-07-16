variable "linux_avs" {
  default = "linux_avs"
}
variable "nb_count" {

}
variable "linux_vm_name" {
  type = string
}
variable "vm-size" {
  default = "standard_B1s"
}
variable "admin-username" {
  
}
variable "private_key" {
  default = "/Users/shekharmehta/Documents/College/Automation/Keys/Keys "
}
variable "public_key" {
  default = "/Users/shekharmehta/Documents/College/Automation/Keys/Keys .pub"
}
variable "os-disk-attr" {
  type = map(string)
  default = {
    storage-account-type = "Premium_LRS"
    disk-size            = "32"
    disk-caching         = "ReadWrite"
  }
}
variable "source_image_info" {
  type = map(string)
  default = {
    os-publisher = "OpenLogic"
    os-offer     = "CentOS"
    os-sku       = "8_2"
    os-version   = "latest"
  }
}

variable "subnet_id" {
}
variable "rg_name" {
  type = string
}
variable "location" {
  type = string
}
variable "storage_account_name" {
  type = string
}
variable "storage_account_key" {
}
variable "storage_act" {
}
variable "common_tags" {
  type    = map(string)
}

