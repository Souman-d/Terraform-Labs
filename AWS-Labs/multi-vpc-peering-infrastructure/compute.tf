# Configures Security Groups and provisions the 4 EC2 instances (1 per subnet). Security groups are configured to allow ICMP (ping) and SSH between all subnet ranges.

# Key Pair Creation
resource "aws_key_pair" "lab_key" {
  key_name   = "aws-lab-key"
  public_key = file("~/.ssh/aws_lab_key.pub")
}

# Security Group for VPC A
resource "aws_security_group" "sg_a" {
  name        = "vpc-a-sg"
  description = "Allow SSH and All ICMP within peer network"
  vpc_id      = aws_vpc.vpc_a.id

  ingress {
    description = "Allow SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow Ping from VPC A and VPC B"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = [var.vpc_a_cidr, var.vpc_b_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "VPC-A-SG" }
}

# Security Group for VPC B
resource "aws_security_group" "sg_b" {
  name        = "vpc-b-sg"
  description = "Allow SSH and All ICMP within peer network"
  vpc_id      = aws_vpc.vpc_b.id

  ingress {
    description = "Allow SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow Ping from VPC A and VPC B"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = [var.vpc_a_cidr, var.vpc_b_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = { Name = "VPC-B-SG" }
}

# ================================
# INSTANCES
# ================================
resource "aws_instance" "ec2_vpc_a_pub" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public_a.id
  vpc_security_group_ids = [aws_security_group.sg_a.id]
  key_name               = aws_key_pair.lab_key.key_name

  tags = { Name = "EC2-VPC-A-Public" }
}

resource "aws_instance" "ec2_vpc_a_priv" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.private_a.id
  vpc_security_group_ids = [aws_security_group.sg_a.id]
  key_name               = aws_key_pair.lab_key.key_name

  tags = { Name = "EC2-VPC-A-Private" }
}

resource "aws_instance" "ec2_vpc_b_pub" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public_b.id
  vpc_security_group_ids = [aws_security_group.sg_b.id]
  key_name               = aws_key_pair.lab_key.key_name

  tags = { Name = "EC2-VPC-B-Public" }
}

resource "aws_instance" "ec2_vpc_b_priv" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.private_b.id
  vpc_security_group_ids = [aws_security_group.sg_b.id]
  key_name               = aws_key_pair.lab_key.key_name

  tags = { Name = "EC2-VPC-B-Private" }
}