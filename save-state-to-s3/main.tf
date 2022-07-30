terraform {
  backend "s3" {
    bucket                  = "terraform-s3-state-0223"
    dynamodb_table          = "terraform-state-lock-dynamo"
    key                     = "my-terraform-project"
    region                  = "us-east-1"
    shared_credentials_file = "~/.aws/credentials"
  }
}

provider "aws" {
  region                  = "us-east-1"
  shared_credentials_file = "~/.aws/credentials"
}


resource "aws_s3_bucket" "New_bucket" {
  bucket = "terraform-s3-state-02231"
  acl    = "private"

  tags = {
    Name = "myBucketTagName"
  }
}
