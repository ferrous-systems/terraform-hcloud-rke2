output "network" {
    value = hcloud_network.cluster.name
}

output "lb_fqdn" {
    value = local.fqdn
}

output "lb_ipv4" {
    depends_on = [
        hcloud_load_balancer_service.k8s_api,
        hcloud_server.master2
    ]
    value = hcloud_load_balancer.cluster.ipv4
}

output "lb_ipv6" {
    depends_on = [
        hcloud_load_balancer_service.k8s_api,
        hcloud_server.master2
    ]
    value = hcloud_load_balancer.cluster.ipv6
}

output "node" {
    value = concat([
        {
            name         = hcloud_server.master0.name
            ipv4_address = hcloud_server.master0.ipv4_address
            ipv6_address = hcloud_server.master0.ipv6_address
        },
        {
            name         = hcloud_server.master1.name
            ipv4_address = hcloud_server.master1.ipv4_address
            ipv6_address = hcloud_server.master1.ipv6_address
        },
        {
            name         = hcloud_server.master2.name
            ipv4_address = hcloud_server.master2.ipv4_address
            ipv6_address = hcloud_server.master2.ipv6_address
        }
    ], [
        for server in hcloud_server.agent : {
            name         = server.name
            ipv4_address = server.ipv4_address
            ipv6_address = server.ipv6_address
        }
    ])
}

output "cluster_ca_certificate" {
    value = local.cluster_ca_certificate
}

output "client_certificate" {
    value = local.client_certificate
}

output "client_key" {
    value = local.client_key
}
