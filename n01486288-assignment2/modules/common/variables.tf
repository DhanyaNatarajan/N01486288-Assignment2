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

variable "log_analytics_workspace" {
    type = map(string)
    default = {
        name = "og-analytics-workspace-6288"
        sku = "PerGB2018"
        ret-in-days = 30
    }
}

variable "recovery_services_vault" {
    type = map(string)
    default = {
        name = "vault-6288"
        sku = "Standard"
    }
}

variable "storage_account" {
    type = map(string)
    default = {
        name = "6288assignment2"
        account_tier = "Standard"
        account_replication_type = "LRS"
    }
}

variable "storage_container" {
    type = map(string)
    default = {
        name = "storage-container-6288"
        container_access_type = "private"
    }
}

variable "storage_blob" {
    type = map(string)
    default = {
        name = "storage_blob-6288"
        type  = "Block"
    }
}
