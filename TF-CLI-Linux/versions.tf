# This file is managed by Terraform Cloud and should not be edited directly.

##################################
### Providers - Cloud Backend ###
terraform {
  cloud {
    organization = "DSD-Terraform-Test"
    workspaces {
      name = "Tf-Cloud-CLI"
    }
  }
}
provider "azurerm" {
  # subscription_id = "6e83f8e1-bcf9-4cf5-8eb2-c9585391d4ee"
  # tenant_id       = "fa3f5c87-6b26-4240-9f12-c4679a19fed9"
  oidc_request_token = true
  use_oidc           = true
  features {}
}