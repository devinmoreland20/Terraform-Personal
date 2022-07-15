#-----root/main.tf

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
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "example"
  }
}


####### EC2
module "compute" {
  source          = "./modules/compute"
  instance_count  = 1
  instance_type   = "t2.micro"
  public_sg       = [aws_security_group.http.id]
  key_name        = "devin-key"
  public_key_path = "/Users/devin/.ssh/devin-key.pub"
  public_subnets  = aws_subnet.example.id
  ami             = "ami-0cff7528ff583bf9a"

}
