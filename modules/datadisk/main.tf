resource "azurerm_managed_disk" "windows_data_disk" {
  name                 = "${var.windows_name}-data-disk"
  location             = var.location
  resource_group_name  = var.resource_group
  storage_account_type = var.storage_account_type
  create_option        = var.create_option
  disk_size_gb         = var.disk_size_gb
  tags                = local.common_tags
}

resource "azurerm_virtual_machine_data_disk_attachment" "windows_data_disk_attach" {
  managed_disk_id    = azurerm_managed_disk.windows_data_disk.id
  virtual_machine_id = var.windows_id
  lun                = var.lun
  caching            = var.data_disk_caching
  depends_on = [azurerm_managed_disk.windows_data_disk]
}

resource "azurerm_managed_disk" "data_disk2" {
  name                 = "linux-centos-vm1-data-disk2"
  location             = var.location
  resource_group_name  = var.resource_group
  storage_account_type = var.storage_account_type
  create_option        = var.create_option
  disk_size_gb         = var.disk_size_gb
  tags = local.common_tags
}

resource "azurerm_virtual_machine_data_disk_attachment" "data_disk_attach2" {
  managed_disk_id    = azurerm_managed_disk.data_disk2.id
  virtual_machine_id = element(var.linux_id, 0)[0]
  lun                = var.lun
  caching            = var.data_disk_caching
  depends_on         = [azurerm_managed_disk.data_disk2]
}


resource "azurerm_managed_disk" "data_disk3" {
  name                 = "linux-centos-vm2-data-disk3"
  location             = var.location
  resource_group_name  = var.resource_group
  storage_account_type = var.storage_account_type
  create_option        = var.create_option
  disk_size_gb         = var.disk_size_gb
  tags = local.common_tags
}

resource "azurerm_virtual_machine_data_disk_attachment" "data_disk_attach3" {
  managed_disk_id    = azurerm_managed_disk.data_disk3.id
  virtual_machine_id = element(var.linux_id, 1)[1]
  lun                = var.lun
  caching            = var.data_disk_caching
  depends_on         = [azurerm_managed_disk.data_disk3]
}
