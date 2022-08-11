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
  vnet          = "vnet"
  vnet_space    = ["10.0.0.0/16"]
  subnet      = "subnet"
  subnet_space = ["10.0.1.0/24"]
  nsg          = "nsg"
  depends_on    = [module.resource_group]
}

module "common" {
  source         = "./modules/common"
  resource_group = module.resource_group.resource_group.name
  location       = module.resource_group.resource_group.location
  depends_on = [module.resource_group]
}

module "vmlinux" {
  source     = "./modules/vmlinux"
  linux_name                 = {n01486288-c-vm1 = "Standard_B1ms"
                                n01486288-c-vm2 = "Standard_B1ms"}
  linux_avs  = "linux-avs"
  linux_rg  = module.resource_group.resource_group.name
  location   = module.resource_group.resource_group.location
  subnet     = module.network.subnet_id
  depends_on = [module.network]
}

module "vmwindows" {
  source              = "./modules/vmwindows"
  resource_group      = module.resource_group.resource_group.name
  location            = module.resource_group.resource_group.location
  depends_on          = [module.network]
  windows_name        = "wsvm-6288"
  subnet_id           = module.network.subnet_id
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
  linux_name   = {n01486288-c-vm1 = "Standard_B1ms"
                  n01486288-c-vm2 = "Standard_B1ms"}
  linux_id = [module.vmlinux.linux_virtual_machine_ids]

}

module "load_balancer" {
  source               = "./modules/loadbalancer"
  rg                  = module.resource_group.resource_group.name
  location             = module.resource_group.resource_group.location
  public_ip_address_id = [module.vmlinux.Linux_public_ip_addresses]
  network_interface_id = [module.vmlinux.network_interface_id]
  depends_on           = [module.network, module.vmlinux]
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