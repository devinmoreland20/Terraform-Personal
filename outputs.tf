# ----root/outputs

# output "vpc_resource_level_tags" {
#   value = aws_vpc.example.tags
# }

# output "vpc_all_tags" {
#   value = aws_vpc.example.tags_all
# }

output "vpc_public_IPv4" {
  value = module.compute.vpc_public_IPv4 #prints out the public IPv4
}
