terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.66.0"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

resource "aws_instance" "Terraform_Web_Server" {
  count         = 3
  ami           = "ami-0b2c9d1f3edcfd709"
  instance_type = "t3.micro"
  tags = {
    Name = "Server-${count.index + 1}"
  }
}

output "public_ip" {
  value = aws_instance.Terraform_Web_Server[*].public_ip
}

# THE FACT THAT THESE FEW LINES WERE ABLE TO DEPLOY THREE INSTANCES OF THE WEB SERVER, EACH WITH A UNIQUE NAME, IS A TESTAMENT TO THE POWER OF TERRAFORM'S COUNT META-ARGUMENT.
# IT ENABLES USERS TO EASILY SCALE THEIR INFRASTRUCTURE WITHOUT DUPLICATING CODE, MAKING IT A VALUABLE TOOL FOR EFFICIENT AND EFFECTIVE INFRASTRUCTURE MANAGEMENT.
