# ------------------------------------------------------------------
# VM 1 Resources (VNet 1 - peer1-subnet)
# ------------------------------------------------------------------

# Public IP for VM 1
resource "azurerm_public_ip" "pip1" {
  name                = "pip-ubuntu-vm1"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

# NSG for VM 1 (Allow SSH)
resource "azurerm_network_security_group" "nsg1" {
  name                = "nsg-ubuntu-vm1"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "Allow_SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# NIC for VM 1
resource "azurerm_network_interface" "nic1" {
  name                = "nic-ubuntu-vm1"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip1.id
  }
}

# Associate NSG to NIC 1
resource "azurerm_network_interface_security_group_association" "nsg_assoc1" {
  network_interface_id      = azurerm_network_interface.nic1.id
  network_security_group_id = azurerm_network_security_group.nsg1.id
}

# Linux VM 1
resource "azurerm_linux_virtual_machine" "vm1" {
  name                            = "vm1-peer1"
  resource_group_name             = azurerm_resource_group.rg.name
  location                        = azurerm_resource_group.rg.location
  size                            = "Standard_D2ls_v7" 
  admin_username                  = "azureuser"
  admin_password                  = "P@ssw0rd1234!" # Use password auth for quick setup
  disable_password_authentication = false

  network_interface_ids = [
    azurerm_network_interface.nic1.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
}

# ------------------------------------------------------------------
# VM 2 Resources (VNet 2 - peer2-subnet)
# ------------------------------------------------------------------

# Public IP for VM 2
resource "azurerm_public_ip" "pip2" {
  name                = "pip-ubuntu-vm2"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

# NSG for VM 2 (Allow SSH)
resource "azurerm_network_security_group" "nsg2" {
  name                = "nsg-ubuntu-vm2"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "Allow_SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

# NIC for VM 2
resource "azurerm_network_interface" "nic2" {
  name                = "nic-ubuntu-vm2"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet2.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.pip2.id
  }
}

# Associate NSG to NIC 2
resource "azurerm_network_interface_security_group_association" "nsg_assoc2" {
  network_interface_id      = azurerm_network_interface.nic2.id
  network_security_group_id = azurerm_network_security_group.nsg2.id
}

# Linux VM 2
resource "azurerm_linux_virtual_machine" "vm2" {
  name                            = "vm2-peer2"
  resource_group_name             = azurerm_resource_group.rg.name
  location                        = azurerm_resource_group.rg.location
  size                            = "Standard_D2ls_v7" 
  admin_username                  = "azureuser"
  admin_password                  = "P@ssw0rd1234!"
  disable_password_authentication = false

  network_interface_ids = [
    azurerm_network_interface.nic2.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
}