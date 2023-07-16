# module for resourse group
module "rgroup-0922" {
  source   = "./modules/rgroup-0922"
  rg-name  = "0922-RG"
  location = "canadacentral"
  common_tags = local.common_tags
}

# module for network
module "network-0922"{
  source                        = "./modules/network-0922"
  rg-name                       = module.rgroup-0922.network-rg-name
  location                      = module.rgroup-0922.network-rg-location
  depends_on                    = [module.rgroup-0922]
  vnet-name                     = "0922-vnet"
  vnet-space                    = ["10.0.0.0/16"]
  subnet-name1                  = "0922-subnet"
  subnet1-address-space         = ["10.0.1.0/24"]
  security-group1               = "0922-sg"
}

# module for common
module "common-0922" {
  source                        = "./modules/common-0922"
  la_name                       = "0922-la"
  storage_account_name          = "str0922"
  rg-name                       = module.rgroup-0922.network-rg-name
  location                      = module.rgroup-0922.network-rg-location
  subnet_id                     = module.network-0922.azurerm_subnet_name
  depends_on                    = [
                                   module.rgroup-0922
                                  ]
  common_tags                   = local.common_tags
}

# module for linux virtual machine
module "vmlinux-0922" {
  source                         = "./modules/vmlinux-0922"
  nb_count                       = 3
  linux_vm_name                  = "linux-vm0922"
  rg_name                        = module.rgroup-0922.network-rg-name
  location                       = module.rgroup-0922.network-rg-location
  subnet_id                      = module.network-0922.azurerm_subnet_name
  depends_on = [
    module.rgroup-0922,
    module.network-0922,
    module.common-0922
  ]
  admin-username                  = "terraform-0922"
  storage_account_name            = module.common-0922.storage_account_name.name
  storage_account_key             = module.common-0922.storage_account_key
  storage_act                     = module.common-0922.storage_account_name
  common_tags                     = local.common_tags
}

# module for windows virtual machine
module "vmwindows-0922" {
  source                          = "./modules/vmwindows-0922"
  windows_vm_name                 = "vmwin-0922"
  windows_username                = "terraform-0922"
  windows_password                = "WindowsP@ssw0rd"  
  rg_name                         = module.rgroup-0922.network-rg-name
  location                        = module.rgroup-0922.network-rg-location
  subnet_id                       = module.network-0922.azurerm_subnet_name
  depends_on                      = [module.common-0922, module.network-0922, module.rgroup-0922]
  storage_account_name            = module.common-0922.storage_account_name
  common_tags                     = local.common_tags
}        

# module for data disk
module "datadisk-0922" {
  source                          = "./modules/datadisk-0922"
  linux-vm-ids                    = module.vmlinux-0922.linux-vm-ids
  windows_vm_id                   = module.vmwindows-0922.windows_vm_id
  location                        = module.rgroup-0922.network-rg-location
  rg_name                         = module.rgroup-0922.network-rg-name
  depends_on                      = [module.rgroup-0922, module.vmwindows-0922, module.vmlinux-0922]
  disk_size_gb                    = 20
  common_tags                     = local.common_tags
}

# module for load balancer
module "loadbalancer-0922" {
  source                          = "./modules/loadbalancer-0922"
  lb_name                         = "lb-0922"
  lb_ip_name                      = "lbpip-0922"
  rg_name                         = module.rgroup-0922.network-rg-name
  location                        = module.rgroup-0922.network-rg-location
  vm_public_ip                    = module.vmlinux-0922.linux-vm-public-ip
  linux-nic-id                    = module.vmlinux-0922.nic_id[0]
  nb_count                        = "3"
  linux_vm_name                   = module.vmlinux-0922.linux-vm-hostname
  subnet_id                       = module.network-0922.azurerm_subnet_name
  depends_on = [
    module.rgroup-0922,
    module.vmlinux-0922,
  ]
  common_tags                     = local.common_tags
}

# module for database
module "database-0922" {
  source                          = "./modules/database-0922"
  db_name                         = "n0922-db"
  server_name                     = "db-0922"
  db_username                     = "psqluser"
  db_pass                         = "psql@12345"
  rg_name                         = module.rgroup-0922.network-rg-name
  location                        = module.rgroup-0922.network-rg-location
  depends_on = [
    module.rgroup-0922
  ]
  common_tags                     = local.common_tags
}