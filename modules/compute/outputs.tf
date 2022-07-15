# ---- compute/outputs

output "vpc_public_IPv4" {
  value = aws_instance.example.public_ip #prints out the public IPv4
}
