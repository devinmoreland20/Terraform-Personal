#-----root/main.tf

module "compute" {
  source          = "./modules/compute"
  instance_count  = 1
  instance_type   = "t2.micro"
  public_sg       = module.networking.public
  key_name        = "devin-key"
  public_key_path = "/Users/devin/.ssh/devin-key.pub"
  public_subnets  = module.networking.aws_subnet
  ami             = "ami-0cff7528ff583bf9a"
}

module "networking" {
  source          = "./modules/networking"
  vpc_cidr        = local.vpc_cidr
  access_ip       = var.access_ip
  security_groups = local.security_groups
  max_subnets     = 2
  public_cidrs    = [for i in range(2, 255, 2) : cidrsubnet(local.vpc_cidr, 8, i)]
  private_cidrs   = [for i in range(1, 255, 2) : cidrsubnet(local.vpc_cidr, 8, i)]
}
