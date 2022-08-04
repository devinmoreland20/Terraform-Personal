# ----- root/main.tf


module "compute" {
  source              = "./modules/compute"
  instance_count      = 2
  ami                 = var.ami
  instance_type       = var.instance_type
  security_groups     = module.security.public_http_sg
  bastion_sg          = module.security.bastion_sg
  public_subnet       = module.networking.aws_public_subnet
  user_data           = file("./userdata.tpl")
  key_name            = var.key_name
  public_key_path     = var.public_key_path
  tg_port             = 80
  lb_target_group_arn = module.loadbalancing.lb_target_group_arn
}

module "networking" {
  source           = "./modules/networking"
  vpc_cidr         = var.vpc_id
  access_ip        = var.local_IP
  private_sn_count = 2
  public_sn_count  = 2
  public_cidrs     = [for i in range(1, 3, 1) : cidrsubnet(var.vpc_id, 8, i)]
  private_cidrs    = [for i in range(3, 5, 1) : cidrsubnet(var.vpc_id, 8, i)]
}

module "loadbalancing" {
  source         = "./modules/loadbalancing"
  public_subnets = module.networking.aws_public_subnet
  tg_port        = 80
  tg_protocol    = "HTTP"
  vpc_id         = module.networking.vpc_id
  #listener_port     = 80
  listener_protocol = "HTTP"
  security_groups   = module.security.public_ALB
  #   lb_healthy_thresold    = 2
  #   lb_unhealthy_threshold = 2
  #   lb_timeout             = 300
  #   lb_interval            = 30
}

module "database" {
  source               = "./modules/database"
  allocated_storage    = 8
  engine               = var.rds_engine
  engine_version       = var.rds_engine_version
  instance_class       = var.rds_instance_class
  db_name              = "Flintlock"
  username             = "Flintlock"
  password             = "Flintlock"
  parameter_group_name = var.rds_parameter_group_name
  security_groups      = module.security.private_database_sg
  subnet_ids           = module.networking.aws_private_subnet
}



module "security" {
  source    = "./modules/security"
  vpc_id    = module.networking.vpc_id
  access_ip = var.local_IP


}
