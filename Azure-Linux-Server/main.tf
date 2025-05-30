## Linux Virtual Machine on Azure using Terraform

#################################
#     Resource Group
#################################
resource "azurerm_resource_group" "linuxvms" {
  name     = var.azurerm_resource_group
  location = var.location
}

#################################
#     Random Password
#################################
resource "random_password" "password" {
  length           = 16
  min_upper        = 2
  min_lower        = 2
  min_numeric      = 2
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

#################################
#     Network
#################################
resource "azurerm_virtual_network" "linuxvn1" {
  name                = "lvmvirtnet1"
  address_space       = ["10.15.0.0/16"]
  location            = azurerm_resource_group.linuxvms.location
  resource_group_name = azurerm_resource_group.linuxvms.name
}

resource "azurerm_subnet" "linuxsub1" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.linuxvms.name
  virtual_network_name = azurerm_virtual_network.linuxvn1.name
  address_prefixes     = ["10.15.2.0/24"]
  depends_on           = [azurerm_virtual_network.linuxvn1]
}

# resource "azurerm_subnet" "linuxsub2" {
#   name                 = "internal2"
#   resource_group_name  = azurerm_resource_group.linuxvms.name
#   virtual_network_name = azurerm_virtual_network.linuxvn1.name
#   address_prefixes     = ["10.8.3.0/24"]
#   depends_on           = [azurerm_virtual_network.linuxvn1]
# }

#################################
#     Network Interface
#################################
resource "azurerm_network_interface" "netinter1" {
  depends_on          = [azurerm_public_ip.lazpubip]
  name                = "linux-nic-1"
  location            = azurerm_resource_group.linuxvms.location
  resource_group_name = azurerm_resource_group.linuxvms.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.linuxsub1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.lazpubip.id
  }
}

#################################
#      Public IP
#################################
resource "azurerm_public_ip" "lazpubip" {
  name                = "LinPubIp1"
  resource_group_name = azurerm_resource_group.linuxvms.name
  location            = azurerm_resource_group.linuxvms.location
  allocation_method   = "Static"

  tags = {
    environment = "DD_Enterprises"
  }
}

#################################
#      NSG - Security Group
#################################
resource "azurerm_network_security_group" "gen_access_nsg" {
  name                = "gen_access_nsg"
  location            = azurerm_resource_group.linuxvms.location
  resource_group_name = azurerm_resource_group.linuxvms.name

  security_rule {
    name              = "GENERIC-RULE"
    priority          = 1001
    direction         = "Inbound"
    access            = "Allow"
    protocol          = "Tcp"
    source_port_range = "*"
    #destination_port_range     = "3389"
    #destination_port_ranges     = "["22","3389","80","8080"]" 
    destination_port_ranges    = ["22", "80", "8080", "443"]
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

#################################
#       NSG Association
#################################
resource "azurerm_network_interface_security_group_association" "nicsgs1" {
  network_interface_id      = azurerm_network_interface.netinter1.id
  network_security_group_id = azurerm_network_security_group.gen_access_nsg.id
}

#################################
#   AZ Storage and Containers
#################################
resource "azurerm_storage_account" "tfstorage" {
  name                     = "tfssstrga1"
  resource_group_name      = azurerm_resource_group.linuxvms.name
  location                 = azurerm_resource_group.linuxvms.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"

  tags = {
    Storage = "Storage1"
  }
}

resource "azurerm_storage_container" "container1" {
  depends_on            = [azurerm_storage_account.tfstorage]
  name                  = "tfssstrgb1"
  storage_account_id    = azurerm_storage_account.tfstorage.id
  container_access_type = "private"
}

# resource "azurerm_storage_container" "container2" {
#   depends_on            = [azurerm_storage_account.tfstorage]
#   name                  = "tfssstrgb2"
#   storage_account_name  = azurerm_storage_account.tfstorage.name
#   container_access_type = "private"
# }

#################################
#   Linux Virtual Machine
#################################
resource "azurerm_linux_virtual_machine" "ubuntudsd1" {
  name                            = "ubuntudsd01"
  resource_group_name             = azurerm_resource_group.linuxvms.name
  location                        = azurerm_resource_group.linuxvms.location
  size                            = "Standard_DS1_v2"
  admin_username                  = "xadministrator"
  admin_password                  = random_password.password.result
  disable_password_authentication = false
  network_interface_ids = [
    azurerm_network_interface.netinter1.id,
  ]

  #   admin_ssh_key {
  #     username   = "adminuser"
  #     public_key = file("~/.ssh/id_rsa.pub")
  #   }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    #offer     = "0001-com-ubuntu-server-jammy" 
    offer   = "ubuntu-24_04-lts"
    sku     = "server"
    version = "latest"
  }
}

#################################################
# Linux VM Extension - Install NGINX
# If you do not need a web server, you can comment this out.
#################################################
resource "azurerm_virtual_machine_extension" "web_server_install" {
  name                       = "nginx-install"
  virtual_machine_id         = azurerm_linux_virtual_machine.ubuntudsd1.id
  publisher                  = "Microsoft.Azure.Extensions"
  type                       = "CustomScript"
  type_handler_version       = "2.1"
  auto_upgrade_minor_version = "true"

  # Define settings for the custom script extension
  settings = <<SETTINGS
 {
  "commandToExecute": "sudo apt update && sudo apt-get install nginx -y && sudo apt-get install jq -y"
 }
SETTINGS

  # Set timeouts for extension creation and deletion
  timeouts {
    create = "3m"
    delete = "3m"
  }
}