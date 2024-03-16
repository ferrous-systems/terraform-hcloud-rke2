output "api_url" {
    value = local.api_url
}

output "lb_ipv4" {
    value = module.cluster.lb_ipv4
}

output "lb_ipv6" {
    value = module.cluster.lb_ipv6
}

output "master" {
    value = module.cluster.master
}

output "agent" {
    value = module.cluster.agent
}

output "longhorn_password" {
    value     = var.use_longhorn ? module.longhorn[0].password : null
    sensitive = true
}
