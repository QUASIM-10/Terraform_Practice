terraform {

  backend "remote" {
    organization = "Quasim_Terraform"

    workspaces {
      name = "getting_started"
    }
  }

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
