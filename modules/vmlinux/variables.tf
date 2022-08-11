locals {
  common_tags = {
    Name = "Dhanya.Natarajan"
    Project = "Automation Project – Assignment 2"
    ContactEmail = "dhanyacse21@gmail.com"
    ExpirationDate = "2022-08-20"
    Environment = "Lab"
  }
}

variable "linux_rg" {
  default = ""
}

variable "location" {
  default = ""
}

variable "subnet" {
  default = ""
}

variable "linux_name" {
  type    = map(string)
  default = {}
 }

variable "vm_size" {
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

variable "linux_publisher" {
  default = "OpenLogic"

}
variable "linux_offer" {
  default = "CentOS"

}
variable "linux_sku" {
  default = "8_2"

}

variable "linux_version" {
  default = "8.2.2020111800"
}

variable "linux_avs" {
    default = ""
}

variable "pub_key" {
  default = "~/.ssh/id_rsa.pub"
}

variable "priv_key" {
  default = "~/.ssh/id_rsa"
}
