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
variable "public_key_path" {
  type    = string
  default = "/Users/devin/.ssh/devin-key.pub"
}
variable "key_name" {
  type    = string
  default = "devin-1993"
}
variable "ami" {
  type    = string
  default = "ami-0cff7528ff583bf9a"
}



