module "cluster" {
    source       = "./cluster"
    network_zone = var.network_zone
    location     = var.location
    domain       = var.domain
    cluster_name = var.cluster_name
    agent_count  = var.agent_count
}

module "dns" {
    source       = "./dns"
    domain       = var.domain
    cluster_name = var.cluster_name
    lb_ipv4      = module.cluster.lb_ipv4
    lb_ipv6      = module.cluster.lb_ipv6
    server       = merge(module.cluster.master, module.cluster.agent)
}
