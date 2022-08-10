resource "azurerm_network_interface" "linux-nic" {
  count               = var.nb_count
  name                = "${var.linux_name}-nic-${format("%1d", count.index + 1)}"
  location            = var.location
  resource_group_name = var.resource_group
  tags                = local.common_tags


  ip_configuration {
    name                          = "${var.linux_name}-ipconfig-${format("%1d", count.index + 1)}"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = element(azurerm_public_ip.linux-pip[*].id, count.index + 1)
  }
}

resource "azurerm_public_ip" "linux-pip" {
  count               = var.nb_count
  name                = "${var.linux_name}-pip-${count.index}"
  resource_group_name = var.resource_group
  location            = var.location
  allocation_method   = "Dynamic"
  domain_name_label   = "n01486288-c-vm${count.index + 1}"
  tags                = local.common_tags

}

data "azurerm_public_ip" "public_ip" {
  count               = var.nb_count
  name                = element(azurerm_public_ip.linux-pip[*].name, count.index + 1)
  resource_group_name = var.resource_group
}

resource "azurerm_linux_virtual_machine" "linux-vm" {
  count               = var.nb_count
  name                = "${var.linux_name}-vm${format("%1d", count.index + 1)}"
  computer_name       = "${var.comp_name}-vm${format("%1d", count.index + 1)}"
  resource_group_name = var.resource_group
  location            = var.location
  size                = var.linux_size
  admin_username      = var.admin_username
  disable_password_authentication = true
  tags                = local.common_tags

  availability_set_id = azurerm_availability_set.linux-avs.id
  network_interface_ids = [
    element(azurerm_network_interface.linux-nic[*].id, count.index + 1)
  ]

  admin_ssh_key {
    username   = var.admin_username
    public_key = file(var.pub_key)
  }

  os_disk {
    name                 = "${var.linux_name}-osdisk-${format("%1d", count.index + 1)}"
    caching              = var.os_disk["caching"]
    storage_account_type = var.os_disk["storage_account_type"]
    disk_size_gb         = var.os_disk["disk_size"]
  }

  source_image_reference {
    publisher = var.centos_linux_os["publisher"]
    offer     = var.centos_linux_os["offer"]
    sku       = var.centos_linux_os["sku"]
    version   = var.centos_linux_os["version"]
  }

  boot_diagnostics {
    storage_account_uri = var.storage_account_uri
  }

  depends_on = [azurerm_availability_set.linux-avs]
}

resource "azurerm_availability_set" "linux-avs" {
  name                         = var.linux_avs
  location                     = var.location
  resource_group_name          = var.resource_group
  platform_update_domain_count = var.linux_avs_value["update_domain"]
  platform_fault_domain_count  = var.linux_avs_value["fault_domain"]
}

resource "azurerm_virtual_machine_extension" "linux-vme" {
  count               = var.nb_count
  name                = "${var.linux_name}-vme-${format("%1d", count.index + 1)}"
  virtual_machine_id   = azurerm_linux_virtual_machine.linux-vm[count.index].id
  publisher            = var.vme["publisher"]
  type                 = var.vme["type"]
  type_handler_version = var.vme["type_handler_version"]

  

  tags                = local.common_tags
}
