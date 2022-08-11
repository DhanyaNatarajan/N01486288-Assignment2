output "vnet" {
  value = azurerm_virtual_network.vnet.name
}

output "address_space" {
  value = azurerm_virtual_network.vnet.address_space
}

output "subnet_name" {
  value = azurerm_subnet.subnet.name
}

output "subnet_id" {
  value = azurerm_subnet.subnet.id
}