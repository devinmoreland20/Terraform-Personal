# ----root/outputs

# output "instances" {
#   value     = { for i in module.compute.instance : i.tags.Name => "i.public_ip:${module.compute.instance_port}" }
#   sensitive = true
# }

output "load_balancer_endpoint" {
  value = module.loadbalancing.lb_endpoint
}

output "instance_public_ip" {
  value = module.compute.instance_public_ip
}
