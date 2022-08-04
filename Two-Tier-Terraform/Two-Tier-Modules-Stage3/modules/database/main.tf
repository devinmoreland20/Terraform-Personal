# ------ module/database/main.tf
resource "aws_db_instance" "project" {
  allocated_storage      = var.allocated_storage
  engine                 = var.engine
  engine_version         = var.engine_version
  instance_class         = var.instance_class
  db_name                = var.db_name
  db_subnet_group_name   = aws_db_subnet_group.project.name
  username               = var.username
  password               = var.password
  parameter_group_name   = var.parameter_group_name
  skip_final_snapshot    = true
  vpc_security_group_ids = [var.security_groups]
}

resource "aws_db_subnet_group" "project" {
  name       = "project"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "My DB subnet group"
  }
}
