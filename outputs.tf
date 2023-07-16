# output for resourse group
output "network-rg-name" {
  value = module.rgroup-0922.network-rg-name
}
output "network-rg-location" {
  value = module.rgroup-0922.network-rg-location
}

# output for network
output "azurerm_subnet_name" {
  value = module.network-0922.azurerm_subnet_id
}
output "virtual_network_name" {
  value = module.network-0922.virtual_network_name.name
}
output "VirtualNetwork-Sapce" {
  value = module.network-0922.virtual_network_name.address_space
}
output "network_security_group_name1" {
  value = module.network-0922.network_security_group_name1.name
}

# output for common
output "log_analytics_workspace_name" {
  value = module.common-0922.log_analytics_workspace_name.name
}
output "recovery_vault_name" {
  value = module.common-0922.recovery_vault_name.name
}
output "storage_account_name" {
  value = module.common-0922.storage_account_name
  sensitive = true
}

# output for linux vm
output "linux-vm-private-ip" {
  value = module.vmlinux-0922.linux-vm-private-ip
}
output "linux-vm-public-ip" {
  value = module.vmlinux-0922.linux-vm-public-ip
}
output "linux_virtual_machine" {
  value = module.vmlinux-0922.linux_virtual_machine
}
output "linux-vm-hostname" {
  value = module.vmlinux-0922.linux-vm-hostname
}

# output for windows vm
output "windows_vm_name" {
  description = "Name of the Windows virtual machine"
  value       = module.vmwindows-0922.windows_vm_name
}
output "windows_vm_id" {
  value = module.vmwindows-0922.windows_vm_id
}
output "windows_vm_dns_labels" {
  description = "DNS label for the Windows virtual machine"
  value       = module.vmwindows-0922.windows_vm_dns_label
}
output "windows_vm_private_ip_address" {
  description = "Private IP address for the Windows virtual machine"
  value       = module.vmwindows-0922.windows_vm_private_ip_address
}
output "windows_vm_public_ip_address" {
  description = "Public IP address for the Windows virtual machine"
  value       = module.vmwindows-0922.windows_vm_public_ip_address
}

# output for load balancer
output "lb_name" {
  value = module.loadbalancer-0922.lb_name
}

# output for database
output "db_server_name" {
  value = module.database-0922.db_name
  sensitive = true
}