resource "azurerm_managed_disk" "linux_datadisk" {
  count                = length(var.linux-vm-ids)
  name                 = "linux-datadisk-${count.index + 1}"
  location             = var.location
  resource_group_name  = var.rg_name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = var.disk_size_gb
  tags                 = var.common_tags
}

resource "azurerm_managed_disk" "windows_datadisk" {
  name                 = "windows-datadisk"
  location             = var.location
  resource_group_name  = var.rg_name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = var.disk_size_gb
  tags                 = var.common_tags
}

resource "azurerm_virtual_machine_data_disk_attachment" "linux_datadisk_attachment" {
  count              = length(var.linux-vm-ids)
  managed_disk_id    = azurerm_managed_disk.linux_datadisk[count.index].id
  virtual_machine_id = element(var.linux-vm-ids, count.index)
  lun                = count.index + 1
  caching            = "ReadWrite"
  depends_on         = [azurerm_managed_disk.linux_datadisk]
}

resource "azurerm_virtual_machine_data_disk_attachment" "windows_datadisk_attachment" {
  managed_disk_id    = azurerm_managed_disk.windows_datadisk.id
  virtual_machine_id = var.windows_vm_id
  lun                = 0
  caching            = "ReadWrite"
  depends_on         = [azurerm_managed_disk.windows_datadisk]
}