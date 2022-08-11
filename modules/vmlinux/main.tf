resource "azurerm_linux_virtual_machine" "vmlinux" {
  for_each              = var.linux_name
  name                  = each.key
  resource_group_name   = var.linux_rg
  location              = var.location
  size                  = var.vm_size
  network_interface_ids = [azurerm_network_interface.linux_nic[each.key].id]
  computer_name         = each.key
  availability_set_id   = azurerm_availability_set.linux_avs.id
  admin_username        = var.admin_username
  tags                  = local.common_tags
  depends_on            = [azurerm_availability_set.linux_avs]

  admin_ssh_key {
    username   = var.admin_username
    public_key = file(var.pub_key)
  }




  source_image_reference {
    publisher = var.linux_publisher
    offer     = var.linux_offer
    sku       = var.linux_sku
    version   = var.linux_version
  }


  os_disk {
    name                 = "${each.key}-os-disk"
    caching              = var.os_disk["caching"]
    storage_account_type = var.os_disk["storage_account_type"]
    disk_size_gb         = var.os_disk["disk_size"]


  }

}

resource "azurerm_network_interface" "linux_nic" {
  for_each        = var.linux_name
  name                = "${each.key}-nic"
  location            = var.location
  resource_group_name = var.linux_rg
  tags = local.common_tags


  ip_configuration {
    name                          = "${each.key}-ipconfig1"
    subnet_id                     = var.subnet
    public_ip_address_id          = azurerm_public_ip.linux_pip[each.key].id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_public_ip" "linux_pip" {
  for_each            = var.linux_name
  name                = "${each.key}-pip"
  resource_group_name = var.linux_rg
  location            = var.location
  allocation_method   = "Dynamic"
  domain_name_label   = each.key
  tags = local.common_tags

}

resource "azurerm_availability_set" "linux_avs" {
  name                         = var.linux_avs
  location                     = var.location
  resource_group_name          = var.linux_rg
  platform_fault_domain_count  = 2
  platform_update_domain_count = 5
  managed                      = true

}

resource "azurerm_virtual_machine_extension" "network-watcher" {
  for_each              = var.linux_name
  name                  = "${each.key}-netwatcher"
  virtual_machine_id = azurerm_linux_virtual_machine.vmlinux[each.key].id
  publisher                  = "Microsoft.Azure.NetworkWatcher"
  type                       = "NetworkWatcherAgentLinux"
  type_handler_version       = "1.4"
  auto_upgrade_minor_version = true
}

