#---- networking/outputs.tf


output "public" {
  value = aws_security_group.public["public"].id
}
