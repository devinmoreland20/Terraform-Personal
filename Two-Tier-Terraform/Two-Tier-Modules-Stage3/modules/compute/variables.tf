# -------- modules/compute/variables

variable "instance_count" {}
variable "instance_type" {}
variable "ami" {}
variable "security_groups" {}
variable "bastion_sg" {}
variable "public_subnet" {}
variable "user_data" {}
variable "key_name" {}
variable "tg_port" {}
variable "lb_target_group_arn" {}
variable "public_key_path" {}

