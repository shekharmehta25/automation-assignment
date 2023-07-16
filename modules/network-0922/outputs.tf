output "virtual_network_name" {
  value = azurerm_virtual_network.network-vnet
}
output "azurerm_subnet_name" {
  value = azurerm_subnet.network-subnet1.id
}
output "azurerm_subnet_id" {
  value = azurerm_subnet.network-subnet1.name
}
output "network_security_group_name1" {
  value = azurerm_network_security_group.nsg1
}