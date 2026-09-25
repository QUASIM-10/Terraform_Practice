terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  backend "remote" {
    organization = "QUASIM-10"

    workspaces {
      name = "provisioners"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

data "aws_vpc" "main" {
  id = "vpc-082f3c9078dbed1f8"
}

resource "aws_security_group" "sg_my_server" {
  name        = "sg_my_server"
  description = "MyServer Security Group"
  vpc_id      = data.aws_vpc.main.id
}

resource "aws_vpc_security_group_ingress_rule" "http" {
  security_group_id = aws_security_group.sg_my_server.id
  description       = "HTTP"
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "ssh" {
  security_group_id = aws_security_group.sg_my_server.id
  description       = "SSH"
  cidr_ipv4         = "102.89.34.31/32"
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
}


resource "aws_vpc_security_group_egress_rule" "all_outbound" {
  security_group_id = aws_security_group.sg_my_server.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDEMDYAeSIvcVo/nsH8X2HrtmiiBJByeb5HYJBY5fySvtAAUalDCOKbiYu4Jh81oAptg9gkmiO/2Qvl/4GtRI7ATW4xde3t/fsIIvgfGB0gPr2ir1nBo0Q8EDBx1mn8D2EyyzhHbI+XJDFWcTCumKho0mCoGNxrv1HI8iDDM+ioIprkuocaUzqYpT8ZdyNT9Az55MOXc7/N+RoRLpGboTEr3NAIIKJmzF36fCjPk+7xsbzNU7Ont0jETlHFgDQtDahFfrg6bExLjP66eghmb5tQzVP24qIWricM2qUML8DzpVCapcUb5UKPjQG0ddcIyzxHesNSEpH90MMQD0gsUDv40kOJglpLxBHDoltEP1LA7w9NPgix+Vfq/ccXRGrP/a/3HGERZJEAeYFm4LblGYSe5kAsXA0YZpb0ZXobT3+xfm2g6xehNYilsFT0e+8fcPJTD8kwhzEIexmJ0Z4OhN+HXi4yoPzKxkfiBAAw5kv9Gm2PuTh/gnR7nMqybavyVk/9AnJaxyWUOU+DOD45ncj1Vvlwm+xTckn79TPFOgZoUhRrw8KDEw0BTaQCqfoXCrK+Yrs4uGigH39Dr0T0PLGQjE2j5QI1Jq0Gc3Paprl5oikJSZHrztHw9CiTcmM1ShDXGIMfQAj0pCnK7sokKcUYHuY3QpZZqnXDRtcJDMNOHQ== user@DESKTOP-3QMBF22"
}

resource "aws_instance" "Web_010_Server" {
  ami                    = "ami-0b2c9d1f3edcfd709"
  instance_type          = "t3.micro"
  key_name               = aws_key_pair.deployer.key_name
  vpc_security_group_ids = [aws_security_group.sg_my_server.id]
  tags = {
    Name = "Provisioner_Server"
  }
}

output "public_ip" {
  value = aws_instance.Web_010_Server.public_ip
}
