terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 4.0"
    }
  }
}

provider "azurerm" {
  subscription_id = "e20eb20b-7ae2-41e0-8859-e917c49d2194"
  features {}
}

locals {
  resource_group_name = "rg-terraform-azure"
  location            = "East US"
}

# 1. Resource Group
resource "azurerm_resource_group" "rg" {
  name     = local.resource_group_name
  location = local.location
}

# 2. Virtual Network
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet1-terraform"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = ["10.0.0.0/16"]
}

# 3. Subnet (Created as a standalone resource for clean referencing)
resource "azurerm_subnet" "subnet" {
  name                 = "subnet1"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

# 4. Public IP Address
resource "azurerm_public_ip" "public_ip" {
  name                = "pip-windows-vm"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Static"
  sku                 = "Standard"

  tags = {
    environment = "Production"
  }
}

# 5. Network Security Group (NSG) with RDP & HTTP Rules
resource "azurerm_network_security_group" "nsg" {
  name                = "nsg-windows-vm"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  # Allow Remote Desktop (RDP)
  security_rule {
    name                       = "Allow_RDP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*" # Consider restricting to your home IP address
    destination_address_prefix = "*"
  }

  # Optional: Allow HTTP traffic
  security_rule {
    name                       = "Allow_HTTP"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# 6. Associate NSG with the Subnet
resource "azurerm_subnet_network_security_group_association" "nsg_assoc" {
  subnet_id                 = azurerm_subnet.subnet.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

# 7. Network Interface (NIC) linking Subnet + Public IP
resource "azurerm_network_interface" "nic" {
  name                = "nic-windows-vm"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip.id
  }
}

# 8. Windows Virtual Machine
resource "azurerm_windows_virtual_machine" "vm" {
  name                = "win-vm-server"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_D2ls_v7"
  admin_username      = "adminuser"
  admin_password      = "P@ssw0rd1234!" 
  network_interface_ids = [
    azurerm_network_interface.nic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter-g2"
    version   = "latest"
  }
}

# Outputs to grab the Public IP once deployed
output "public_ip_address" {
  value       = azurerm_public_ip.public_ip.ip_address
  description = "Connect using RDP: <ip_address>:3389"
}

resource "azurerm_managed_disk" "data_disk" {
  name                 = "data-disk"
  location             = azurerm_resource_group.rg.location
  resource_group_name  = azurerm_resource_group.rg.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = 16
}
# Then we need to attach the data disk to the Azure virtual machine
resource "azurerm_virtual_machine_data_disk_attachment" "disk_attach" {
  managed_disk_id    = azurerm_managed_disk.data_disk.id
  virtual_machine_id = azurerm_windows_virtual_machine.vm.id
  lun                = "0"
  caching            = "ReadWrite"
  depends_on = [
    azurerm_windows_virtual_machine.vm,
    azurerm_managed_disk.data_disk
  ]
}