output "azurerm_public_ip" {
  description = "Linux Public IP"
  value       = azurerm_public_ip.lazpubip.ip_address
}

output "random_password" {
  description = "Random Password for Linux VM"
  value       = random_password.password.result
  sensitive   = true
}

output "azurerm_linux_virtual_machine" {
  description = "Linux VM Name"
  value       = azurerm_linux_virtual_machine.ubuntudsd1.name
}

output "azurerm_storage_container" {
  description = "Linux Container Name"
  value       = azurerm_storage_container.container1.name
}

output "azurerm_resource_group" {
  description = "Azure RG Name"
  value       = azurerm_resource_group.linuxvms.name
}