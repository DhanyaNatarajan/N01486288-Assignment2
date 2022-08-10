#Modules
module "resource_group" {
  source   = "./modules/resource_group"
  resource_group      = "assignment2-RG-6288"
  location = "australiasoutheast"
}

module "network" {
  source         = "./modules/network"
  resource_group = module.resource_group.resource_group.name
  location       = module.resource_group.resource_group.location
  nsg            = "nsg"
}

module "common" {
  source         = "./modules/common"
  resource_group = module.resource_group.resource_group.name
  location       = module.resource_group.resource_group.location
  depends_on = [module.resource_group]
}

module "vmlinux" {
  source              = "./modules/vmlinux"
  resource_group      = module.resource_group.resource_group.name
  location            = module.resource_group.resource_group.location
  linux_name          = "lvm-6288"
  comp_name           = "lvm-6288"
  subnet_id           = module.network.subnet.id
  storage_account_uri = module.common.storage_account.primary_blob_endpoint
  depends_on          = [module.network]
}

module "vmwindows" {
  source              = "./modules/vmwindows"
  resource_group      = module.resource_group.resource_group.name
  location            = module.resource_group.resource_group.location
  depends_on          = [module.network]
  windows_name        = "wsvm-6288"
  subnet_id           = module.network.subnet.id
  storage_account_uri = module.common.storage_account.primary_blob_endpoint
}

module "datadisk" {
  source         = "./modules/datadisk"
  resource_group = module.resource_group.resource_group.name
  location       = module.resource_group.resource_group.location
  depends_on = [
    module.vmlinux,
    module.vmwindows
  ]
  windows_name = module.vmwindows.Windows_hostname
  windows_id   = module.vmwindows.Windows_vm.id
  linux_name = {
    lvm-6288-vm-1 = 0
    lvm-6288-vm-2 = 1
  }
  linux_id = [module.vmlinux.Linux_id]

}

module "loadbalancer" {
  source         = "./modules/loadbalancer"
  resource_group = module.resource_group.resource_group.name
  location       = module.resource_group.resource_group.location
  linux_name = {
    lvm-6288-vm-1 = 0
    lvm-6288-vm-2 = 1
  }
  linux_network_interface_id = [module.vmlinux.Linux_network_interface_id]
  linux_pip_id               = [module.vmlinux.Linux_public_ip_addresses_id]
  depends_on = [
    module.vmlinux,
    module.vmwindows,
    module.network
  ]
}

module "database" {
  source         = "./modules/database"
  resource_group = module.resource_group.resource_group.name
  location       = module.resource_group.resource_group.location
  depends_on     = [module.network]
}

resource "null_resource" "linux_provisioner" {
  depends_on = [module.datadisk]
  provisioner "local-exec" {
    command = "export ANSIBLE_HOST_KEY_CHECKING=False && ansible-playbook --private-key ~/.ssh/id_rsa -i hosts groupX-playbook.yml"
  }
}