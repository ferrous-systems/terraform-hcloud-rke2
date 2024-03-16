output "network" {
    value = hcloud_network.private.name
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

output "fqdn" {
    depends_on = [
        hcloud_load_balancer_service.k8s_api,
        hcloud_server.master2
    ]
    value = local.fqdn
}

output "api" {
    depends_on = [
        hcloud_load_balancer_service.k8s_api,
        hcloud_server.master2
    ]
    value = local.api
}

output "cluster_ca_certificate" {
    value = local.kubeconfig.clusters[0].cluster.certificate-authority-data
}

output "client_certificate" {
    value = local.kubeconfig.users[0].user.client-certificate-data
}

output "client_key" {
    value     = local.kubeconfig.users[0].user.client-key-data
    sensitive = true
}

output "ssh_private_key" {
    value     = tls_private_key.root.private_key_openssh
    sensitive = true
}

output "master" {
    value = [
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
    ]
}

output "agent" {
    value = [
        for server in hcloud_server.agent : {
            name         = server.name
            ipv4_address = server.ipv4_address
            ipv6_address = server.ipv6_address
        }
    ]
}
