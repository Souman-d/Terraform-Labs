terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.55.0"
    }
  }
}

provider "aws" {
  region = ap-south-1
}

resource "aws_instance" "terraformEc2_2" {
  ami = "ami-0b910d1016287a5e7"
  instance_type = "t3.micro"

  tags = {
    Name = "SampleServer"
  }
}