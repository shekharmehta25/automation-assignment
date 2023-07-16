variable "disk_size_gb" {
  type        = number

}

variable "linux-vm-ids" {
  type = list(string)
}

variable "windows_vm_id" {
  type        = string
  default     = ""
}
variable "common_tags" {
  type    = map(string)
}

variable "location" {

}
variable "rg_name" {

}