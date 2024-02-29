output "lb_ipv4" {
    value = hcloud_load_balancer.cluster.ipv4
}

output "lb_ipv6" {
    value = hcloud_load_balancer.cluster.ipv6
}

output "master" {
    value = {
        for server in hcloud_server.master : server.name => {
            ipv4_address = server.ipv4_address
            ipv6_address = server.ipv6_address
        }
    }
}

output "agent" {
    value = {
        for server in hcloud_server.agent : server.name => {
            ipv4_address = server.ipv4_address
            ipv6_address = server.ipv6_address
        }
    }
}

#output "kubeconfig" {
#    value = replace(data.remote_file.kubeconfig.content,
#        "https://127.0.0.1:6443", "https://${local.fqdn}:6443")
#}
