#-----root/main.tf

resource "aws_vpc" "example" {
  cidr_block = local.vpc_cidr
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.example.id

  tags = {
    Name = "main"
  }
}

resource "aws_subnet" "example" {
  vpc_id     = aws_vpc.example.id
  cidr_block = "10.0.1.0/24"

  tags = {
    Name = "Main"
  }
}

module "compute" {
  source          = "./modules/compute"
  instance_count  = 1
  instance_type   = "t2.micro"
  public_sg       = module.networking.public
  key_name        = "devin-key"
  public_key_path = "/Users/devin/.ssh/devin-key.pub"
  public_subnets  = aws_subnet.example.id
  ami             = "ami-0cff7528ff583bf9a"
  #security_groups = local.security_groups

}

module "networking" {
  source          = "./modules/networking"
  vpc_cidr        = aws_vpc.example.cidr_block
  vpc_id          = aws_vpc.example.id
  access_ip       = var.access_ip
  security_groups = local.security_groups
  max_subnets     = 2
  public_cidrs    = [for i in range(2, 255, 2) : cidrsubnet(local.vpc_cidr, 8, i)]
  private_cidrs   = [for i in range(1, 255, 2) : cidrsubnet(local.vpc_cidr, 8, i)]
}
