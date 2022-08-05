# -------- modules/compute/outputs.tf

output "instance_public_ip" {
  value = join(",", aws_instance.project.*.public_ip)
}

output "instance_bastion_ip" {
  value = join(",", aws_instance.bastion.*.public_ip)
}

output "instance_private_ip" {
  value = join(",", aws_instance.project.*.private_ip)
}
