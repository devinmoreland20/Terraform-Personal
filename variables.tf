# ----- root/varibles.tf

variable "aws_region" {
  default = "us-east-1"
}
variable "access_ip" {
  type = string
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}


