# ---------- root/variables.tf
variable "aws_region" {
  default = "us-east-1"
}
variable "vpc_id" {
  default = "10.0.0.0/16"
}
variable "ami" {
  default = "ami-090fa75af13c156b4"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "key_name" {
  default = "tfkey.pub"
}
variable "public_key_path" {
  default = "/Users/devin/.ssh/tfkey.pub"
}

variable "public_access_cidr" {
  default = "0.0.0.0/0"
}

variable "local_IP" {
  default = "76.177.24.199/32"
}

variable "rds_engine" {
  default = "mysql"
}
variable "rds_engine_version" {
  default = "5.7"
}
variable "rds_instance_class" {
  default = "db.t2.micro"
}
variable "rds_name" {
  default = "mydb"
}
variable "rds_username" {
  default = "foo"
}

variable "rds_password" {
  default = "foobar0223"
}

variable "rds_parameter_group_name" {
  default = "default.mysql5.7"
}

variable "name_length" {
  default = "Devin"
}
