terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.66.0"
    }
  }
}

# DEFAULT provider (us-east-1)
provider "aws" {
  profile = "default"
  region  = "us-east-1"
}

# ALIASED provider (us-west-2)
provider "aws" {
  alias   = "west"
  profile = "default"
  region  = "us-west-2"
}

# Data source: latest Amazon Linux 2023 AMI in the EAST (default provider)
data "aws_ami" "east_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Data source: latest Amazon Linux 2023 AMI in the WEST (aliased provider)
data "aws_ami" "west_ami" {
  provider    = aws.west
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# Resource in the EAST (default provider)
resource "aws_instance" "east_server" {
  ami           = data.aws_ami.east_ami.id
  instance_type = "t3.micro"
  tags          = { Name = "East-Server" }
}

# Resource in the WEST (aliased provider)
resource "aws_instance" "west_server" {
  provider      = aws.west
  ami           = data.aws_ami.west_ami.id
  instance_type = "t3.micro"
  tags          = { Name = "West-Server" }
}

output "east_public_ip" {
  value = aws_instance.east_server.public_ip
}

output "west_public_ip" {
  value = aws_instance.west_server.public_ip
}
