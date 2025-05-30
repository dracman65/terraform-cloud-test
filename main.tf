
provider "azurerm" {
  features {}

  use_oidc = true
  client_id = "4eb64827-89a9-4e67-a282-f6c592fbd3d2"
  tenant_id = "fa3f5c87-6b26-4240-9f12-c4679a19fed9"
  subscription_id = "6e83f8e1-bcf9-4cf5-8eb2-c9585391d4ee"
}

resource "azurerm_resource_group" "tfstate" {
  name     = "dsdtftest01"
  location = "East US"
}

resource "azurerm_storage_account" "tfstate" {
  name                     = "tfdeploy01"
  resource_group_name      = azurerm_resource_group.tfstate.name
  location                 = azurerm_resource_group.tfstate.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "tfstate" {
  name                  = "tfstate"
  storage_account_id    = azurerm_storage_account.tfstate.id
  container_access_type = "private"
}