### Providers ###
terraform {
  #required_version = ">=1.2"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      #version = "> 3.0"
    }
    random = {
      source  = "hashicorp/random"
      #version = "> 3.0"
    }
  }
}
provider "azurerm" {
  subscription_id = "6e83f8e1-bcf9-4cf5-8eb2-c9585391d4ee"
  tenant_id       = "fa3f5c87-6b26-4240-9f12-c4679a19fed9"
  oidc_request_token = true
  use_oidc = true
  features {}
}