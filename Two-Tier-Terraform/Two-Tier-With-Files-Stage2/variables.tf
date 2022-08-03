# -----root/variables.tf-------

variable "aws_region" {
  default = "us-east-1"
}
variable "access_ip" {
  type = string
}

variable "ami" {
  type    = string
  default = "ami-090fa75af13c156b4"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "key_name" {
  type    = string
  default = "tfkey.pub"
}
variable "public_key" {
  type    = string
  default = "/Users/devin/.ssh/tfkey.pub"
}


variable "instance_count" {
  default = 2
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}
variable "access_cidr" {
  default = "0.0.0.0/0"
}

variable "subnet_count" {
  default = 2
}
variable "public_cidrs" {
  type = list(any)
  default = ["10.0.1.0/24",
  "10.0.2.0/24"]

}
variable "private_cidrs" {
  type = list(any)
  default = ["10.0.3.0/24",
  "10.0.4.0/24"]
}

variable "availability_zone" {
  type    = list(any)
  default = ["us-east-1a", "us-east-1b"]
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
