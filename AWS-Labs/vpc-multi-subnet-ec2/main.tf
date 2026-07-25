# ==============================================================================
# LEVEL 1: PROVIDER & TERRAFORM SETTINGS
# Purpose: Defines the Terraform version, required AWS provider, and region.
# ==============================================================================

terraform {
  required_providers {
    aws = {
        source  = "hashicorp/aws"
        version = "6.55.0"
  }
} 
}

provider "aws" {
  region = "ap-south-1"
}

# ==============================================================================
# LEVEL 2: LOCAL VARIABLES
# Purpose: Stores reusable constants to maintain consistent resource naming.
# ==============================================================================
locals {
  project = "project-01"
}


# ==============================================================================
# LEVEL 3: BASE NETWORKING INFRASTRUCTURE
# Purpose: Provisions the primary Network (VPC) and dynamically scales subnets.
# ==============================================================================
resource "aws_vpc" "my-vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "${local.project}-vpc"
  }
}

# Creates 2 Subnets (10.0.0.0/24 and 10.0.1.0/24) using count index
resource "aws_subnet" "main" {
  count      = 2
  vpc_id     = aws_vpc.my-vpc.id
  cidr_block = "10.0.${count.index}.0/24"

  tags = {
    Name = "${local.project}-subnet-${count.index}"
  }
}


# ==============================================================================
# LEVEL 4: COMPUTE RESOURCES & DYNAMIC PLACEMENT
# Purpose: Iterates over var.ec2_map to spin up instances and evenly distributes 
#          them across the subnets using a round-robin modulo algorithm.
# ==============================================================================
resource "aws_instance" "main" {
  for_each = var.ec2_map

  ami           = each.value.ami
  instance_type = each.value.instance_type

  # Round-robin subnet assignment logic:
  # Takes the index of the current key, divides by total subnets (2), 
  # and uses the remainder (0 or 1) to select the subnet ID.
  subnet_id = element(aws_subnet.main[*].id, index(keys(var.ec2_map), each.key) % length(aws_subnet.main))

  tags = {
    Name = "${local.project}-instance-${each.key}"
  }
}


# ==============================================================================
# LEVEL 5: OUTPUTS & EXPORTED DATA
# Purpose: Exposes critical generated infrastructure data (e.g., Subnet IDs).
# ==============================================================================
output "aws_subnet_id" {
  description = "ID of the second created subnet"
  value       = aws_subnet.main[1].id
}