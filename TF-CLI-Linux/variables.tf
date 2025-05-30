variable "azurerm_resource_group" {
  description = "The name of the resource group in which the resources will be created"
  type        = string
  default     = "linuxstdvms20"
}

variable "location" {
  description = "The location where resources will be created"
  type        = string
  default     = "eastus2"
}


# variable "default_tags" {
#   description = "Tags to set for certain resources"
#   type        = map(string)
#   default     = {
#     name        = "external_ip",
#     deployed_by = "terraform",
#     owner       = "tfdd_class"
#   }
# }