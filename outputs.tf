output "lb_ipv4" {
    value = module.cluster.lb_ipv4
}

output "lb_ipv6" {
    value = module.cluster.lb_ipv6
}

output "master_ipv4s" {
    value = module.cluster.master_ipv4s
}

output "master_ipv6s" {
    value = module.cluster.master_ipv6s
}

output "agent_ipv4s" {
    value = module.cluster.agent_ipv4s
}

output "agent_ipv6s" {
    value = module.cluster.agent_ipv6s
}
