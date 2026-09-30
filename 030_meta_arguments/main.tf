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

resource "aws_s3_bucket" "bucket" {
  bucket = "2443402424109-depends-on"
  depends_on = [
    aws_instance.Terraform_Web_Server
  ]

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}

resource "aws_instance" "Terraform_Web_Server" {
  ami           = "ami-0b2c9d1f3edcfd709"
  instance_type = "t3.micro"

}

output "public_ip" {
  value = aws_instance.Terraform_Web_Server.public_ip
}
