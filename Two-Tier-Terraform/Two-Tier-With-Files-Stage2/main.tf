# ----- root/main.tf

resource "aws_vpc" "project" {
  cidr_block       = var.vpc_cidr #our cidr is now a variable. 
  instance_tenancy = "default"
  tags = {
    Name = "Project"
  }
}

resource "aws_internet_gateway" "project_gw" {
  vpc_id = aws_vpc.project.id

  tags = {
    Name = "Project"
  }
}

#We created our public subnets under one resource block by using count to create multiple. 
resource "aws_subnet" "public_project_subnet" {
  count             = var.subnet_count
  vpc_id            = aws_vpc.project.id
  cidr_block        = var.public_cidrs[count.index]      #This interates over a list of CIDRS
  availability_zone = var.availability_zone[count.index] #Iterates over a like of AZ's
  tags = {
    Name = "project public ${count.index}"
  }
}

#We created our private subnets under one resource block by using count to create multiple. 
resource "aws_subnet" "private_project_subnet" {
  count             = var.subnet_count
  vpc_id            = aws_vpc.project.id
  cidr_block        = var.private_cidrs[count.index]
  availability_zone = var.availability_zone[count.index]
  tags = {
    Name = "project private ${count.index}"
  }
}

resource "aws_default_route_table" "project_default" {
  default_route_table_id = aws_vpc.project.default_route_table_id
}

resource "aws_route_table" "public_project_route_table" {
  vpc_id = aws_vpc.project.id

  route {
    cidr_block = var.access_cidr
    gateway_id = aws_internet_gateway.project_gw.id
  }

  tags = {
    Name = "Project"
  }
}

#we now only have one public RT assc. that associates however many subnets we have in public sn to this RT
resource "aws_route_table_association" "public_route" {
  count          = var.subnet_count
  subnet_id      = aws_subnet.public_project_subnet[count.index].id
  route_table_id = aws_route_table.public_project_route_table.id
}

#Private route table and RT Association
resource "aws_route_table" "private_project_route_table" {
  vpc_id = aws_vpc.project.id

  tags = {
    Name = "Project"
  }
}

#we now only have one private RT assc. that associates however many subnets we have in private sn to this RT
resource "aws_route_table_association" "private_route_" {
  count          = var.subnet_count
  subnet_id      = aws_subnet.private_project_subnet[count.index].id
  route_table_id = aws_route_table.private_project_route_table.id
}

resource "aws_lb" "project_lb" {
  name                       = "project-lb"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.public_ALB.id]
  subnets                    = aws_subnet.public_project_subnet[*].id
  enable_deletion_protection = false # if true it can cuase problems or it wont destroy


  tags = {
    Environment = "project"
  }
}

resource "aws_lb_listener" "project_lb_listener" {
  load_balancer_arn = aws_lb.project_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.project_lb_tg.arn
  }
}

resource "aws_lb_target_group" "project_lb_tg" {
  name     = "project-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.project.id
}

#We now only have one TG attachment that uses all the instances made from this target id resource. 
resource "aws_lb_target_group_attachment" "project" {
  count            = var.instance_count
  target_group_arn = aws_lb_target_group.project_lb_tg.arn
  target_id        = aws_instance.project_front_end[count.index].id
  port             = 80
}

resource "aws_instance" "project_front_end" {
  count                       = var.instance_count
  ami                         = var.ami
  instance_type               = var.instance_type
  vpc_security_group_ids      = [aws_security_group.public_http_sg.id]
  subnet_id                   = aws_subnet.public_project_subnet[count.index].id
  associate_public_ip_address = true
  user_data                   = file("./userdata.tpl")
  key_name                    = aws_key_pair.key_pair.key_name

  tags = {
    Name = "project ${count.index}"
  }
}

resource "aws_key_pair" "key_pair" {
  key_name   = var.key_name
  public_key = file(var.public_key)
}

# resource "aws_db_instance" "project" {
#   allocated_storage      = 8
#   engine                 = var.rds_engine
#   engine_version         = var.rds_engine_version
#   instance_class         = var.rds_instance_class
#   db_name                = var.rds_name
#   db_subnet_group_name   = aws_db_subnet_group.project.name
#   username               = var.rds_username
#   password               = var.rds_password
#   parameter_group_name   = var.rds_parameter_group_name
#   skip_final_snapshot    = true
#   vpc_security_group_ids = [aws_security_group.private_database_sg.id]
# }

# resource "aws_db_subnet_group" "project" {
#   name       = "project"
#   subnet_ids = aws_subnet.private_project_subnet[*].id

#   tags = {
#     Name = "My DB subnet group"
#   }
# }

resource "aws_security_group" "public_ALB" {
  name        = "HTTP_Access_via_ALB"
  description = "Allow HTTP inbound traffic via ALB"
  vpc_id      = aws_vpc.project.id

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

resource "aws_security_group" "public_http_sg" {
  name        = "HTTP_Access"
  description = "Allow HTTP/SSH inbound traffic"
  vpc_id      = aws_vpc.project.id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.public_ALB.id]
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
  vpc_id      = aws_vpc.project.id

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
