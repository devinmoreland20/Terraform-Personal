# --- networking/variables

variable "access_ip" {
  type = string
}
variable "vpc_cidr" {
  type = string
}

variable "security_groups" {
}

variable "max_subnets" {
  type = number
}

variable "public_cidrs" {
  type = list(any)
}

variable "private_cidrs" {
}

variable "public_sn_count" {
  type = number

}

variable "private_sn_count" {
  type = number
}

variable "aws_nat_gateway" {

}
