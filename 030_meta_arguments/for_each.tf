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
  for_each = {
    a = "t3.micro"
    b = "t3.micro"
    c = "t3.micro"
  }
  ami           = "ami-0b2c9d1f3edcfd709"
  instance_type = each.value
  tags = {
    Name = "Server-${each.key}"
  }
}

output "public_ip" {
  value = values(aws_instance.Terraform_Web_Server)[*].public_ip
}

# SET a,b,c TO THE RESPECTIVE INSTANCE TYPES YOU WANT TO CREATE. THE FOR_EACH META-ARGUMENT ALLOWS YOU TO CREATE MULTIPLE INSTANCES OF A RESOURCE BASED ON A MAP OR SET OF VALUES, MAKING IT EASY TO SCALE YOUR INFRASTRUCTURE WITHOUT DUPLICATING CODE. 
#EACH INSTANCE WILL HAVE A UNIQUE NAME BASED ON THE KEY IN THE MAP, AND THE PUBLIC IP ADDRESSES OF ALL INSTANCES WILL BE OUTPUTTED AS A LIST.

# AND THIS ALSO CREATES 3 INSTANCES OF THE WEB SERVER, EACH WITH A UNIQUE NAME, SIMILAR TO THE COUNT META-ARGUMENT EXAMPLE.
