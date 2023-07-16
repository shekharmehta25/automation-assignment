variable "rg_name" {

}
variable "location" {

}
variable "storage_account_name" {

}
variable "windows_vm_name" {

}
variable "windows_avs" {
  type    = string
  default = "windows_avs_set"
}

variable "subnet_id" {
}

variable "windows_OS_disk" {
  type        = map(string)
  description = "Attributes for Window machine OS disk"
  default = {
    storage_account_type = "StandardSSD_LRS"
    Disk_size            = "128"
    caching              = "ReadWrite"
  }
}
variable "windows_OS" {
  type        = map(string)
  description = "Windows OS information"
  default = {
    Publisher = "MicrosoftWindowsServer"
    Offer     = "WindowsServer"
    Sku       = "2016-Datacenter"
    Version   = "latest"
  }
}

variable "windows_username" {
  type        = string
}
variable "windows_password" {
  type        = string
}
variable "common_tags" {
  type    = map(string)
}