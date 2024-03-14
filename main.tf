locals {
    setup_dns = var.hdns_token != ""
}

module "cluster" {
    source       = "./cluster"
    use_dns      = local.setup_dns
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
    setup_dns    = local.setup_dns
    domain       = var.domain
    cluster_name = var.cluster_name
    lb_ipv4      = module.cluster.lb_ipv4
    lb_ipv6      = module.cluster.lb_ipv6
}

module "hcloud" {
    source                = "./hcloud"
    hcloud_token          = var.hcloud_token
    network               = module.cluster.network
    hcloud_ccm_version    = var.hcloud_ccm_version
    hcloud_csi_version    = var.use_hcloud_storage ? var.hcloud_csi_version : null
    default_storage_class = !var.use_longhorn
}

module "addons" {
    source           = "./addons"
    fqdn             = module.cluster.fqdn
    acme_email       = var.acme_email
    longhorn_version = var.use_longhorn ? var.longhorn_version : null
    headlamp_version = var.use_headlamp ? var.headlamp_version : null
}
