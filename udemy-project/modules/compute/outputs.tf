# ---- compute/outputs

# output "instance" {
#   value     = aws_instance.example[*]
#   sensitive = true
# }


output "instance_public_ip" {
  value = join(",", aws_instance.example.*.public_ip)
}
