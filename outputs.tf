output "api_url" {
    value = module.cluster.api_url
}

output "lb_ipv4" {
    value = module.cluster.lb_ipv4
}

output "lb_ipv6" {
    value = module.cluster.lb_ipv6
}

output "node" {
    value = module.cluster.node
}

output "longhorn_password" {
    value     = module.addons.longhorn_password
    sensitive = true
}
