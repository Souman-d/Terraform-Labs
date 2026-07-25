# Configures the VPC Peering Connection, auto-accepts it, and injects route table entries across both VPCs.

# ================================
# VPC PEERING CONNECTION
# ================================
resource "aws_vpc_peering_connection" "peering" {
  peer_vpc_id = aws_vpc.vpc_b.id
  vpc_id      = aws_vpc.vpc_a.id
  auto_accept = true

  tags = {
    Name = "VPC-A-to-VPC-B-Peering"
  }
}

# ================================
# ROUTES FOR VPC A (to reach VPC B)
# ================================

# Route from VPC-A Public Route Table -> VPC-B CIDR
resource "aws_route" "vpc_a_pub_to_vpc_b" {
  route_table_id            = aws_route_table.public_a.id
  destination_cidr_block    = var.vpc_b_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.peering.id
}

# Route from VPC-A Private Route Table -> VPC-B CIDR
resource "aws_route" "vpc_a_priv_to_vpc_b" {
  route_table_id            = aws_route_table.private_a.id
  destination_cidr_block    = var.vpc_b_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.peering.id
}

# ================================
# ROUTES FOR VPC B (to reach VPC A)
# ================================

# Route from VPC-B Public Route Table -> VPC-A CIDR
resource "aws_route" "vpc_b_pub_to_vpc_a" {
  route_table_id            = aws_route_table.public_b.id
  destination_cidr_block    = var.vpc_a_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.peering.id
}

# Route from VPC-B Private Route Table -> VPC-A CIDR
resource "aws_route" "vpc_b_priv_to_vpc_a" {
  route_table_id            = aws_route_table.private_b.id
  destination_cidr_block    = var.vpc_a_cidr
  vpc_peering_connection_id = aws_vpc_peering_connection.peering.id
}