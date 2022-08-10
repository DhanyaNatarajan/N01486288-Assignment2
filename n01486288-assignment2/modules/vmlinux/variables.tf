locals {
  common_tags = {
    Name = "Dhanya.Natarajan"
    Project = "Automation Project – Assignment 2"
    ContactEmail = "dhanyacse21@gmail.com"
    ExpirationDate = "2022-08-20"
    Environment = "Lab"
  }
}

variable "resource_group"{
    default = ""
}

variable "location" {
    default = ""
}

variable "subnet_id" {
    default = ""
}

variable "linux_name" {
  default = ""
}

variable "linux_size" {
  default = "Standard_B1ms"
}

variable "admin_username" {
  default = "dhanya216"
}

variable "admin_password" {
  default = "n01486288#"
}

variable "os_disk" {
  type = map(string)
  default = {
    storage_account_type = "Premium_LRS"
    disk_size            = 32
    caching              = "ReadWrite"
  }
}

variable "centos_linux_os" {
  type = map(string)
  default = {
    publisher = "OpenLogic"
    offer     = "CentOS"
    sku       = "8_2"
    version   = "latest"
  }
}

variable "linux_avs" {
    default = "linux-avs-6288"
}

variable "linux_avs_value" {
  type = map(string)
  default = {
    update_domain = 10
    fault_domain  = 2
  }
}

variable "storage_account_uri" {
    default = ""
}

variable "nb_count" {
  default = 2
}

variable "vme" {
  type = map(string)
  default = {
    publisher  = "Microsoft.Azure.NetworkWatcher"
    type  = "NetworkWatcherAgentLinux"
    type_handler_version ="1.4"
  }
}

variable "pub_key" {
  default = "~/.ssh/id_rsa.pub"
}

variable "priv_key" {
  default = "~/.ssh/id_rsa"
}

variable "comp_name" {
  default = ""
}