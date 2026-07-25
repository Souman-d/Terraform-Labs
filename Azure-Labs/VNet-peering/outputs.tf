output "vm1_public_ip" {
  value       = azurerm_public_ip.pip1.ip_address
  description = "Public IP of VM1"
}

output "vm1_private_ip" {
  value       = azurerm_linux_virtual_machine.vm1.private_ip_address
  description = "Private IP of VM1 (Subnet 1: 10.0.1.x)"
}

output "vm2_public_ip" {
  value       = azurerm_public_ip.pip2.ip_address
  description = "Public IP of VM2"
}

output "vm2_private_ip" {
  value       = azurerm_linux_virtual_machine.vm2.private_ip_address
  description = "Private IP of VM2 (Subnet 2: 10.1.1.x)"
}