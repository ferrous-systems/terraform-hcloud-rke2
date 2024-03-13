module "cluster" {
    source       = "./cluster"
    location     = var.location
    domain       = var.domain
    cluster_name = var.cluster_name
    master_type  = var.master_type
    agent_type   = var.agent_count
    agent_count  = var.agent_count
    image        = var.image
    rke2_version = var.rke2_version
}

module "dns" {
    source       = "./dns"
    domain       = var.domain
    cluster_name = var.cluster_name
    lb_ipv4      = module.cluster.lb_ipv4
    lb_ipv6      = module.cluster.lb_ipv6
}

module "hcloud" {
    source       = "./hcloud"
    hcloud_token = var.hcloud_token
    network      = module.cluster.network
}

module "addons" {
    source        = "./addons"
    fqdn          = module.cluster.fqdn
    acme_email    = var.acme_email
    longhorn_user = var.longhorn_user
}
