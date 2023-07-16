resource "azurerm_public_ip" "public_ip" {
  name                = var.lb_ip_name
  location            = var.location
  resource_group_name = var.rg_name
  allocation_method   = "Static"
  tags                = var.common_tags
}
resource "azurerm_lb" "Load_balancer" {
  name                = var.lb_name
  location            = var.location
  resource_group_name = var.rg_name
  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = azurerm_public_ip.public_ip.id
  }
  tags = var.common_tags
}
resource "azurerm_lb_backend_address_pool" "backend_pool" {
  loadbalancer_id = azurerm_lb.Load_balancer.id
  name            = "backendpool"
}

resource "azurerm_network_interface_backend_address_pool_association" "backend_pool_assoc" {
  count                   = length(var.linux-nic-id)
  network_interface_id    = element(var.linux-nic-id, count.index)
  backend_address_pool_id = azurerm_lb_backend_address_pool.backend_pool.id
  ip_configuration_name   = "linux-vm0922-ipconfig${count.index + 1}"
  
}
resource "azurerm_lb_rule" "lb_rule" {
  loadbalancer_id                = azurerm_lb.Load_balancer.id
  name                           = "http-LBRule"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = "PublicIPAddress"
}
resource "azurerm_lb_probe" "lb_probe" {
  loadbalancer_id = azurerm_lb.Load_balancer.id
  name            = "http-running-probe"
  port            = 80
}
