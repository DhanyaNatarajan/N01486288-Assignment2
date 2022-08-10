terraform {
  backend "azurerm" {
    resource_group_name  = "tfstateN01486288RG"
    storage_account_name = "tfstaten01486288sa"
    container_name       = "tfstatefiles"
    key                  = "tfstate"
    access_key           = "oyZ+mExxqEXaVRkyUfegUgDbmT1EPP9I9rjYyqDAPJ5gyn9HxDmKQdBvmjwuHilsvKLpKuHdx+NM+AStCiYL4g=="
  }
}