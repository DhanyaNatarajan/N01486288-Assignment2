#Resource group
output "resource_group"{
    value = module.resource_group.resource_group.name
}

#Network
output "virtual_network" {
  value = module.network.vnet
}
output "subnet_name" {
  value = module.network.subnet_name
}

#Common
output "log_analytics_workspace" {
  value = module.common.log_analytics_workspace.name
}
output "recovery_services_vault" {
  value = module.common.recovery_services_vault.name
}
output "storage_account" {
  value = module.common.storage_account.name
}

#Linux
output "Linux_hostname" {
  value = module.vmlinux.Linux_hostname
}

output "Linux_private_ip_addresses" {
  value = module.vmlinux.Linux_private_ip_addresses
}

output "Linux_public_ip_addresses" {
  value = module.vmlinux.Linux_public_ip_addresses
}

output "Linux_domain_names" {
  value = module.vmlinux.linux_domain_names
}

output "linux_nic" {
  value = module.vmlinux.linux_nic
}

#Windows
output "Windows_hostname" {
  value = module.vmwindows.Windows_hostname
}
output "Windows_public_ip_addresses" {
  value = module.vmwindows.Windows_public_ip_addresses
}
output "Windows_private_ip_address" {
  value = module.vmwindows.Windows_private_ip_address
}
output "Windows_dns" {
  value = module.vmwindows.Windows_dns
}
