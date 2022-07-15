#### ---- compute/main.tf


resource "aws_key_pair" "devin-key" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)
}


resource "aws_instance" "example" {
  ami                         = "ami-0cff7528ff583bf9a"
  subnet_id                   = var.public_subnets
  instance_type               = var.instance_type
  vpc_security_group_ids      = var.public_sg
  associate_public_ip_address = true #needed to give it a public IPV4
  key_name                    = aws_key_pair.devin-key.id
}


