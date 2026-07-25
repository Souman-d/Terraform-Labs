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

# Create a VPC
resource "aws_vpc" "my_vpc" {
  cidr_block           = "10.1.0.0/16"
  tags = {
    Name = "my_vpc"
  }
}

# Private Subnet
resource "aws_subnet" "private_subnet" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.1.1.0/24"
  tags = {
    Name = "private_subnet"
  }
}

# Public Subnet
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.1.2.0/24"
  tags = {
    Name = "public_subnet"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "my_igw"
  }
}

# Route Table
resource "aws_route_table" "my_route_table" {
  vpc_id = aws_vpc.my_vpc.id
  
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.my_igw.id
    }
}

# Associate Route Table with Public Subnet
resource "aws_route_table_association" "public_subnet_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.my_route_table.id
}

#Instance creation
resource "aws_instance" "my_instance" {
  ami = "ami-0b910d1016287a5e7"
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.public_subnet.id

  tags = {
    Name = "my_instance"
  }
}