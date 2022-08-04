# ----root/providers.tf-------
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.24.0"
    }
  }
}


provider "aws" {
  region = var.aws_region #This will be our defualt region for our infrastructure to deploy into. 

}
