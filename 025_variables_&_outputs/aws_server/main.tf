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
  ami           = "ami-0b2c9d1f3edcfd709"
  instance_type = var.instance_type #"t2.nano" WON'T RUN COS IT IS NOT AVAILABLE FOR FREE PLAN ACCOUNTS.

}

provider "aws" {
  profile = "default"
  region  = "us-east-1"
}


output "public_ip" {
  value     = aws_instance.Terraform_Web_Server.public_ip
  sensitive = true
}
