/* Azure Storage with Container 

URL's
- https://learn.microsoft.com/en-us/rest/api/storageservices/get-container-acl
- https://intelequia.com/blog/post/automating-azure-application-gateway-ssl-certificate-renewals-with-let-s-encrypt-and-azure-automation
- https://methodpoet.com/blob-container-sub-directory/

*/

### Providers - Non-Cloud ###
# terraform {
#   #required_version = ">=1.2"

#   required_providers {
#     azurerm = {
#       source  = "hashicorp/azurerm"
#       #version = "> 3.0"
#     }
#     random = {
#       source  = "hashicorp/random"
#       #version = "> 3.0"
#     }
#   }
# }

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

##################################
### Resource Group and Location ###
resource "azurerm_resource_group" "example" {
  name     = var.resource_group
  location = var.location
}

resource "random_string" "stg" {
  length  = 8
  upper   = false
  special = false
}

##################################
### Storage Account ##
resource "azurerm_storage_account" "storage1" {
  name                     = "octo-${random_string.stg.result}"
  resource_group_name      = var.resource_group
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"

  tags = {
    environment = "OCTO Work"
  }
}

##################################
### Container ###
resource "azurerm_storage_container" "azstgcont01" {
  name                  = "octowkblb01"
  storage_account_id    = azurerm_storage_account.storage1.id
  container_access_type = "blob"
}