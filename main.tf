#-----Create-EC2/main.tf

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.22.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = {
      Environment = "Test"
      Name        = "create-ec2"
    }
  }
}


output "vpc_resource_level_tags" {
  value = aws_vpc.example.tags
}

output "vpc_all_tags" {
  value = aws_vpc.example.tags_all
}

output "vpc_public_IPv4" {
  value = aws_vpc.example.tags_all
}



resource "aws_vpc" "example" {
  cidr_block = "10.0.0.0/16"
}


resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.example.id

  tags = {
    Name = "main"
  }
}

resource "aws_subnet" "example" {
  vpc_id     = aws_vpc.example.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "Main"
  }
}

# resource "aws_route_table" "example" {
#   vpc_id = aws_vpc.example.id

#   route {
#     cidr_block = "10.0.1.0/24"
#     gateway_id = aws_internet_gateway.gw.id
#   }
#   tags = {
#     Name = "example"
#   }
# }

# resource "aws_route" "r" {
#   route_table_id            = aws_route_table.example.id
#   destination_cidr_block    = "10.0.1.0/24"
# }

# resource "aws_route_table_association" "a" {
#   subnet_id      = aws_subnet.example.id
#   route_table_id = aws_route_table.example.id
# }

resource "aws_security_group" "http" {
  name        = "http"
  description = "Allow http inbound traffic"
  vpc_id      = aws_vpc.example.id

  ingress {
    description = "http"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.example.cidr_block]
  }


  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "example"
  }
}


####### EC2

resource "aws_instance" "example" {
  ami                         = "ami-0cff7528ff583bf9a"
  subnet_id                   = aws_subnet.example.id
  instance_type               = "t2.micro"
  vpc_security_group_ids      = [aws_security_group.http.id]
  associate_public_ip_address = true #needed to give it a public IPV4
  key_name                    = "Mac"
}


