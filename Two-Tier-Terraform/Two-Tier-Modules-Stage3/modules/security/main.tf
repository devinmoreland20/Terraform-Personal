# ------- module/security/main.tf


resource "aws_security_group" "public_ALB" {
  name        = "HTTP_Access_via_ALB"
  description = "Allow HTTP inbound traffic via ALB"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "project"
  }
}

resource "aws_security_group" "bastion_sg" {
  name        = "ssh_only_bastion"
  description = "traffic via Bastion only"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.access_ip]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "project"
  }
}



resource "aws_security_group" "public_http_sg" {
  name        = "HTTP_Access"
  description = "Allow HTTP/SSH inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.public_ALB.id]
  }

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "project"
  }
}

resource "aws_security_group" "private_database_sg" {
  name        = "MYSQL_Access"
  description = "Allow MYSQL inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.public_http_sg.id]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # -1 means all protocols 
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "project"
  }
}
