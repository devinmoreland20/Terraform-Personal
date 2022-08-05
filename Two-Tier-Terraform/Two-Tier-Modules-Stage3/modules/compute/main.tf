#------ module/compute/main.tf

resource "aws_instance" "project" {
  count                       = var.instance_count
  ami                         = var.ami
  instance_type               = var.instance_type
  vpc_security_group_ids      = [var.security_groups]
  subnet_id                   = var.public_subnet[count.index]
  associate_public_ip_address = true
  user_data                   = var.user_data
  key_name                    = var.key_name

  tags = {
    Name = "project public instance ${count.index}"
  }
}

resource "aws_lb_target_group_attachment" "project" {
  count            = var.instance_count
  target_group_arn = var.lb_target_group_arn
  target_id        = aws_instance.project[count.index].id
  port             = var.tg_port
}

resource "aws_instance" "bastion" {
  count                       = 1
  ami                         = var.ami
  instance_type               = var.instance_type
  vpc_security_group_ids      = [var.bastion_sg]
  subnet_id                   = var.public_subnet[count.index]
  associate_public_ip_address = true
  user_data                   = var.user_data
  key_name                    = var.key_name
  tags = {
    Name = "project Bastion instance ${count.index}"
  }
}


