# Handles the core network stack: VPCs, Subnets, Internet Gateways, NAT Gateways, and base Route Tables.

terraform {
  required_version = ">= 1.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Data source for dynamic AMI discovery (Amazon Linux 2023)
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023.*-x86_64"]
  }
}

# ================================
# VPC A NETWORK
# ================================
resource "aws_vpc" "vpc_a" {
  cidr_block           = var.vpc_a_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = { Name = "VPC-A" }
}

resource "aws_internet_gateway" "igw_a" {
  vpc_id = aws_vpc.vpc_a.id
  tags   = { Name = "IGW-VPC-A" }
}

resource "aws_subnet" "public_a" {
  vpc_id                  = aws_vpc.vpc_a.id
  cidr_block              = cidrsubnet(var.vpc_a_cidr, 8, 1) # 10.1.1.0/24
  map_public_ip_on_launch = true
  tags                    = { Name = "VPC-A-Public-Subnet" }
}

resource "aws_subnet" "private_a" {
  vpc_id     = aws_vpc.vpc_a.id
  cidr_block = cidrsubnet(var.vpc_a_cidr, 8, 2) # 10.1.2.0/24
  tags       = { Name = "VPC-A-Private-Subnet" }
}

# NAT Gateway for VPC A Private Subnet outbound internet
resource "aws_eip" "nat_a_eip" {
  domain     = "vpc"
  depends_on = [aws_internet_gateway.igw_a]
}

resource "aws_nat_gateway" "nat_a" {
  allocation_id = aws_eip.nat_a_eip.id
  subnet_id     = aws_subnet.public_a.id
  tags          = { Name = "NAT-GW-VPC-A" }
}

resource "aws_route_table" "public_a" {
  vpc_id = aws_vpc.vpc_a.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_a.id
  }
  tags = { Name = "VPC-A-Public-RT" }
}

resource "aws_route_table" "private_a" {
  vpc_id = aws_vpc.vpc_a.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_a.id
  }
  tags = { Name = "VPC-A-Private-RT" }
}

resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public_a.id
}

resource "aws_route_table_association" "private_a" {
  subnet_id      = aws_subnet.private_a.id
  route_table_id = aws_route_table.private_a.id
}

# ================================
# VPC B NETWORK
# ================================
resource "aws_vpc" "vpc_b" {
  cidr_block           = var.vpc_b_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = { Name = "VPC-B" }
}

resource "aws_internet_gateway" "igw_b" {
  vpc_id = aws_vpc.vpc_b.id
  tags   = { Name = "IGW-VPC-B" }
}

resource "aws_subnet" "public_b" {
  vpc_id                  = aws_vpc.vpc_b.id
  cidr_block              = cidrsubnet(var.vpc_b_cidr, 8, 1) # 10.2.1.0/24
  map_public_ip_on_launch = true
  tags                    = { Name = "VPC-B-Public-Subnet" }
}

resource "aws_subnet" "private_b" {
  vpc_id     = aws_vpc.vpc_b.id
  cidr_block = cidrsubnet(var.vpc_b_cidr, 8, 2) # 10.2.2.0/24
  tags       = { Name = "VPC-B-Private-Subnet" }
}

# NAT Gateway for VPC B Private Subnet outbound internet
resource "aws_eip" "nat_b_eip" {
  domain     = "vpc"
  depends_on = [aws_internet_gateway.igw_b]
}

resource "aws_nat_gateway" "nat_b" {
  allocation_id = aws_eip.nat_b_eip.id
  subnet_id     = aws_subnet.public_b.id
  tags          = { Name = "NAT-GW-VPC-B" }
}

resource "aws_route_table" "public_b" {
  vpc_id = aws_vpc.vpc_b.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw_b.id
  }
  tags = { Name = "VPC-B-Public-RT" }
}

resource "aws_route_table" "private_b" {
  vpc_id = aws_vpc.vpc_b.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_b.id
  }
  tags = { Name = "VPC-B-Private-RT" }
}

resource "aws_route_table_association" "public_b" {
  subnet_id      = aws_subnet.public_b.id
  route_table_id = aws_route_table.public_b.id
}

resource "aws_route_table_association" "private_b" {
  subnet_id      = aws_subnet.private_b.id
  route_table_id = aws_route_table.private_b.id
}