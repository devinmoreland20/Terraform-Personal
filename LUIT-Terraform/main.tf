terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  alias  = "us-east-1" #this is a alias that you can use to reference the provider
  region = "us-east-1"
}

resource "aws_instance" "app_server" {
  provider      = aws.us-east-1 # this is how to reference a provider
  ami           = "ami-830c94e3"
  instance_type = "t2.micro"

  tags = {
    Name = "ExampleAppServerInstance"
  }
}

