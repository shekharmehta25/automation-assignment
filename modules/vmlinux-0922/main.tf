resource "azurerm_availability_set" "avail_set" {
  name                         = var.linux_avs
  location                     = var.location
  resource_group_name          = var.rg_name
  platform_update_domain_count = 5
  platform_fault_domain_count  = var.nb_count
}
resource "azurerm_network_interface" "vm-net-interface" {
  count               = var.nb_count
  name                = "${var.linux_vm_name}-nic${format("%1d", count.index + 1)}"
  location            = var.location
  resource_group_name = var.rg_name
  ip_configuration {
    name                          = "${var.linux_vm_name}-ipconfig${format("%1d", count.index + 1)}"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = element(azurerm_public_ip.vm-public-ip[*].id, count.index + 1)
  }
  tags = var.common_tags
}

resource "azurerm_public_ip" "vm-public-ip" {
  count               = var.nb_count
  name                = "${var.linux_vm_name}-pip${format("%1d", count.index + 1)}"
  resource_group_name = var.rg_name
  location            = var.location
  allocation_method   = "Dynamic"
  tags                = var.common_tags
  domain_name_label   = "${lower(replace(var.linux_vm_name, "/[^a-z0-9-]/", ""))}${format("%1d", count.index + 1)}"

}
resource "azurerm_linux_virtual_machine" "vm-linux" {
  count               = var.nb_count
  name                = "${var.linux_vm_name}-${format("%1d", count.index + 1)}"
  computer_name       = "${var.linux_vm_name}-${format("%1d", count.index + 1)}"
  resource_group_name = var.rg_name
  location            = var.location
  size                = var.vm-size
  admin_username      = var.admin-username
  availability_set_id = azurerm_availability_set.avail_set.id
  tags                = var.common_tags
  network_interface_ids = [
    element(azurerm_network_interface.vm-net-interface[*].id, count.index + 1)
  ]
  depends_on = [
    azurerm_availability_set.avail_set
  ]
  boot_diagnostics {
    storage_account_uri = var.storage_act.primary_blob_endpoint
  }
  admin_ssh_key {
    username   = var.admin-username
    public_key = file("/Users/shekharmehta/Documents/College/Automation/Keys/Keys .pub")
  }
  os_disk {
    name                 = "${var.linux_vm_name}-os-disk${format("%1d", count.index + 1)}"
    caching              = var.os-disk-attr["disk-caching"]
    storage_account_type = var.os-disk-attr["storage-account-type"]
    disk_size_gb         = var.os-disk-attr["disk-size"]
  }
  source_image_reference {
    publisher = var.source_image_info["os-publisher"]
    offer     = var.source_image_info["os-offer"]
    sku       = var.source_image_info["os-sku"]
    version   = var.source_image_info["os-version"]
  }
}
resource "azurerm_virtual_machine_extension" "network-watcher" {
  count                      = var.nb_count
  name                       = "network-watcher-${count.index + 1}"
  virtual_machine_id         = azurerm_linux_virtual_machine.vm-linux[count.index].id
  publisher                  = "Microsoft.Azure.NetworkWatcher"
  type                       = "NetworkWatcherAgentLinux"
  type_handler_version       = "1.0"
  auto_upgrade_minor_version = true
  tags                       = var.common_tags

  settings = <<SETTINGS
    {
      "xmlCfg": ""
    }
SETTINGS

  protected_settings = <<PROTECTED_SETTINGS
    {
      "storageAccountName": "${var.storage_account_name}",
      "storageAccountKey": "${var.storage_account_key.primary_access_key}"
    }
PROTECTED_SETTINGS
}


resource "azurerm_virtual_machine_extension" "azure_monitor" {
  count                      = var.nb_count
  name                       = "azure-monitor-${count.index + 1}"
  virtual_machine_id         = azurerm_linux_virtual_machine.vm-linux[count.index].id
  publisher                  = "Microsoft.Azure.Monitor"
  type                       = "AzureMonitorLinuxAgent"
  type_handler_version       = "1.0"
  auto_upgrade_minor_version = true
  tags                       = var.common_tags

  settings = <<SETTINGS
    {
      
    }
SETTINGS

}