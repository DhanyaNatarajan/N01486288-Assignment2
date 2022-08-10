locals {
  common_tags = {
    Name = "Dhanya.Natarajan"
    Project = "Automation Project – Assignment 2"
    ContactEmail = "dhanyacse21@gmail.com"
    ExpirationDate = "2022-08-20"
    Environment = "Lab"
  }
}
variable "resource_group" {
  default = ""
}

variable "location" {
  default = ""
}
