resource "azurerm_availability_set" "windows_availability_set" {
  name                         = var.windows_avs
  location                     = var.location
  resource_group_name          = var.rg_name
  platform_fault_domain_count  = 2
  platform_update_domain_count = 5
}

resource "azurerm_windows_virtual_machine" "windows_vm" {
  name                  = var.windows_vm_name
  location              = var.location
  resource_group_name   = var.rg_name
  network_interface_ids = [azurerm_network_interface.windows_nic.id]
  size                  = "Standard_B1s"
  admin_username        = var.windows_username
  admin_password        = var.windows_password
  tags                  = var.common_tags


  os_disk {
    name                 = "${var.windows_vm_name}-windows_OS_disk"
    caching              = var.windows_OS_disk.caching
    storage_account_type = var.windows_OS_disk.storage_account_type
    disk_size_gb         = var.windows_OS_disk.Disk_size
  }

  source_image_reference {
    publisher = var.windows_OS["Publisher"]
    offer     = var.windows_OS["Offer"]
    sku       = var.windows_OS["Sku"]
    version   = var.windows_OS["Version"]
  }

  winrm_listener {
    protocol = "Http"
  }
  boot_diagnostics {
    storage_account_uri = var.storage_account_name.primary_blob_endpoint
  }
}

resource "azurerm_network_interface" "windows_nic" {
  name                = "${var.windows_vm_name}-nic"
  location            = var.location
  resource_group_name = var.rg_name

  ip_configuration {
    name                          = "${var.windows_vm_name}-ipconfig"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.windows_vm_public_ip_name.id
  }
}

resource "azurerm_public_ip" "windows_vm_public_ip_name" {
  name                = "${var.windows_vm_name}-pip"
  resource_group_name = var.rg_name
  location            = var.location
  allocation_method   = "Dynamic"
  tags                = var.common_tags
  domain_name_label   = var.windows_vm_name
}


resource "azurerm_virtual_machine_extension" "windows-vm-extension" {
  name                       = "IaaSAntimalware"
  publisher                  = "Microsoft.Azure.Security"
  type                       = "IaaSAntimalware"
  type_handler_version       = "1.3"
  auto_upgrade_minor_version = "true"
  virtual_machine_id         = azurerm_windows_virtual_machine.windows_vm.id

  settings = <<SETTINGS
      {
        "AntimalwareEnabled": true
      }
    SETTINGS

  protected_settings = <<PROTECTED_SETTINGS
      {
        "AntimalwareEnabled": true
      }
    PROTECTED_SETTINGS
}





