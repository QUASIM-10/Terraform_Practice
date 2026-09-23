terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.66.0"
    }
  }
}

provider "aws" {
  # Configuration options
  profile = "default"
  region  = "us-east-1"

}

provider "aws" {
  profile = "default"
  region  = "eu-west-1"
  alias   = "eu"
}

variable "instance_type" {
  type = string
}

locals {
  project_name = "QUASIM"
}

resource "aws_instance" "Terraform_Web_Server" {
  ami           = "ami-0b2c9d1f3edcfd709"
  instance_type = var.instance_type #"t2.nano" WON'T RUN COS IT IS NOT AVAILABLE FOR FREE PLAN ACCOUNTS.

  tags = {
    Name = "MyTerraformServer_$(local.project_name)"
  }

}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  providers = {
    aws = aws.eu
  }

  name = "my_terraform_vpc"
  cidr = "10.0.0.0/16"

  azs             = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}


output "instance_ip_address" {
  value = aws_instance.Terraform_Web_Server.public_ip
}

output "ami_number" {
  value = aws_instance.Terraform_Web_Server.ami
}

output "detailed_private_ip" {
  value       = aws_instance.Terraform_Web_Server.private_ip
  description = "This is the private IP address of the instance."
  sensitive   = false
}

output "instance_details" {
  value = {
    id            = aws_instance.Terraform_Web_Server.id
    public_ip     = aws_instance.Terraform_Web_Server.public_ip
    private_ip    = aws_instance.Terraform_Web_Server.private_ip
    ami           = aws_instance.Terraform_Web_Server.ami
    instance_type = aws_instance.Terraform_Web_Server.instance_type
    az            = aws_instance.Terraform_Web_Server.availability_zone
  }
}
