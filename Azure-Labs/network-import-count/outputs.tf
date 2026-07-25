output "public_subnet_ids" {
  value       = azurerm_subnet.public[*].id
  description = "IDs of the created public subnets"
}

output "private_subnet_ids" {
  value       = azurerm_subnet.private[*].id
  description = "IDs of the created private subnets"
}