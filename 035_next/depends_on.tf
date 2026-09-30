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

# ACTIVE BLOCK: the bucket carries depends_on, so it waits for the web server.
# Create order: aws_instance.Terraform_Web_Server first, then aws_s3_bucket.bucket.
# (On destroy the order reverses: bucket destroyed first, then the instance.)
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

# COMMENTED-OUT ALTERNATIVE: here the web server carries depends_on, so it waits for the bucket.
# Create order: aws_s3_bucket.bucket first, then aws_instance.Terraform_Web_Server.
# (On destroy the order reverses: instance destroyed first, then the bucket.)
/*
resource "aws_s3_bucket" "bucket" {
  bucket = "2443402424109-depends-on"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}

resource "aws_instance" "Terraform_Web_Server" {
  ami           = "ami-0b2c9d1f3edcfd709"
  instance_type = "t3.micro"
  depends_on = [
    aws_s3_bucket.bucket
  ]

}
*/

output "public_ip" {
  value = aws_instance.Terraform_Web_Server.public_ip
}

