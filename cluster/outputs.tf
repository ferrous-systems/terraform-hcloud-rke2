output "lb_ipv4" {
    value = hcloud_load_balancer.cluster.ipv4
}

output "lb_ipv6" {
    value = hcloud_load_balancer.cluster.ipv6
}

output "master_ipv4s" {
    value = hcloud_server.master.*.ipv4_address
}

output "master_ipv6s" {
    value = hcloud_server.master.*.ipv6_address
}

output "agent_ipv4s" {
    value = hcloud_server.agent.*.ipv4_address
}

output "agent_ipv6s" {
    value = hcloud_server.agent.*.ipv6_address
}
