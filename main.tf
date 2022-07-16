#-----root/main.tf

module "compute" {
  source              = "./modules/compute"
  instance_count      = 2
  instance_type       = "t2.micro"
  public_sg           = module.networking.public
  key_name            = "devin-key"
  public_key_path     = "/Users/devin/.ssh/devin-key.pub"
  public_subnets      = module.networking.aws_subnet
  user_data           = file("modules/compute/userdata.tpl")
  ami                 = "ami-0cff7528ff583bf9a"
  tg_port             = 80
  lb_target_group_arn = module.loadbalancing.lb_target_group_arn
}

module "networking" {
  source           = "./modules/networking"
  vpc_cidr         = local.vpc_cidr
  access_ip        = var.access_ip
  security_groups  = local.security_groups
  max_subnets      = 6
  private_sn_count = 2
  public_sn_count  = 2
  public_cidrs     = [for i in range(2, 255, 2) : cidrsubnet(local.vpc_cidr, 8, i)]
  private_cidrs    = [for i in range(1, 255, 2) : cidrsubnet(local.vpc_cidr, 8, i)]
}

module "loadbalancing" {
  source                 = "./modules/loadbalancing"
  public_sg              = module.networking.public
  public_subnets         = module.networking.aws_subnet
  tg_port                = 80
  tg_protocol            = "HTTP"
  vpc_id                 = module.networking.vpc_id
  listener_port          = 80
  listener_protocol      = "HTTP"
  security_groups        = module.networking.public
  lb_healthy_thresold    = 2
  lb_unhealthy_threshold = 2
  lb_timeout             = 3
  lb_interval            = 30

}
