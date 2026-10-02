/*
terraform
required_providers

provider
locals
resource
variables
outputs
*/

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.67.0"
    }
  }
}

locals {
  name        = "Terraform_Server"
  owner       = "Quasim"
  server      = "${local.owner}-Server"
  environment = "Dev_ops"
  team        = "COMPUTING"
}

provider "aws" {
  region = var.region
}

resource "aws_instance" "Third_testing_server" {
  ami           = var.ami
  instance_type = var.instance_type

  tags = {
    Name        = "Third_testing_server"
    Environment = local.environment
    Team        = local.team
  }
}

variable "region" {
  description = "the region of the instance"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "the type of instance being used"
  type        = string
  default     = "t3.micro"
}

variable "ami" {
  description = "the ami of the instance"
  type        = string
  default     = "ami-07f9c6534b9c70941"
}

output "public_ip_address" {
  value = aws_instance.Third_testing_server.public_ip
}

output "private_ip_address" {
  value = aws_instance.Third_testing_server.private_ip
}

output "instance_type" {
  value = aws_instance.Third_testing_server.instance_type
}

output "instance_id" {
  value = aws_instance.Third_testing_server.id
}
