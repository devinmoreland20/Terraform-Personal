# ------ modules/networking/variables.tf
variable "vpc_cidr" {}
variable "access_ip" {}
variable "private_sn_count" {}
variable "public_sn_count" {}
variable "public_cidrs" {
  type = list(any)
}
variable "private_cidrs" {
  type = list(any)
}

