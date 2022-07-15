#---- networking/outputs.tf
output "vpc_id" {
  value = aws_vpc.example.id
}

output "public" {
  value = aws_security_group.public["public"].id
}

output "aws_subnet" {
  value = aws_subnet.example.id
}
