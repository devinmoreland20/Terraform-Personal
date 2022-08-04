# ------ root/providers.tf
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.24.0"
    }
  }
  cloud {
    organization = "Flintlocks-Terraform"
    workspaces {
      name = "LUIT-Project"
    }
  }
}

provider "aws" {
  region = var.aws_region

}
