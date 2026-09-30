terraform {

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.66.0"
    }
  }
}

variable "instance_type" {
  type        = string
  description = "The type of the instance to be created."
  sensitive   = true

  validation {
    condition     = contains(["t2.micro", "t3.micro", "t4g.micro"], var.instance_type)
    error_message = "The instance type must be one of: t2.micro, t3.micro, or t4g.micro."
  }
}

resource "aws_instance" "Terraform_Web_Server" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type #"t2.nano" WON'T RUN COS IT IS NOT AVAILABLE FOR FREE PLAN ACCOUNTS.

}

provider "aws" {
  profile = "default"
  region  = "us-east-1"
}


data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}



output "public_ip" {
  value     = aws_instance.Terraform_Web_Server.public_ip
  sensitive = true
}
