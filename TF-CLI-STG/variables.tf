##################################
### Variables ##

variable "resource_group" {
  type        = string
  default     = "storageacctdsd10"
  description = "Resource Group Name."
}

variable "location" {
  type        = string
  default     = "eastus2"
  description = "(optional) describe your variable"
}