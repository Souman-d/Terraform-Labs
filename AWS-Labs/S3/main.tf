terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.55.0"
    }
  }
}

variable "region" {
 description = "The AWS region to create resources in."
  type        = string
  default     = "ap-south-1"
  }
