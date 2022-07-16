# --- networking/main.tf
resource "aws_vpc" "example" {
  cidr_block = var.vpc_cidr
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.example.id

  tags = {
    Name = "main"
  }
}
data "aws_availability_zones" "available" {}


resource "random_shuffle" "az_list" {
  input        = data.aws_availability_zones.available.names
  result_count = var.max_subnets
}


resource "aws_subnet" "example" {
  count                   = var.public_sn_count
  vpc_id                  = aws_vpc.example.id
  cidr_block              = var.public_cidrs[count.index]
  map_public_ip_on_launch = true
  availability_zone       = random_shuffle.az_list.result[count.index]

  tags = {
    Name = "Main"
  }
}


resource "aws_subnet" "private_sn" {
  count                   = 2
  vpc_id                  = aws_vpc.example.id
  cidr_block              = var.private_cidrs[count.index]
  map_public_ip_on_launch = true
  availability_zone       = random_shuffle.az_list.result[count.index]

  tags = {
    Name = "Main"
  }
}
resource "aws_security_group" "public" {
  for_each    = var.security_groups
  name        = each.value.name
  description = each.value.description
  vpc_id      = aws_vpc.example.id
  dynamic "ingress" {
    for_each = each.value.ingress
    content {
      from_port   = ingress.value.from
      to_port     = ingress.value.to
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks #this is the ip to access it, think your IP
    }
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}

resource "aws_default_route_table" "default" {
  default_route_table_id = aws_vpc.example.default_route_table_id
}



resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.example.id
}

resource "aws_route" "r" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  depends_on             = [aws_route_table.public_rt]
  gateway_id             = aws_internet_gateway.gw.id
}

resource "aws_route_table_association" "a" {
  count          = var.public_sn_count
  subnet_id      = aws_subnet.example[count.index].id
  route_table_id = aws_route_table.public_rt.id
}





resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.example.id
}

# resource "aws_route" "r2" {
#   route_table_id         = aws_route_table.private_route_table.id
#   destination_cidr_block = var.vpc_cidr
#   depends_on             = [aws_route_table.private_route_table]
# }

resource "aws_route_table_association" "b" {
  count          = var.private_sn_count
  subnet_id      = aws_subnet.private_sn[count.index].id
  route_table_id = aws_route_table.private_route_table.id
}

