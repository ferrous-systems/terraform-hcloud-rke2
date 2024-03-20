locals {
    setup_dns = nonsensitive(var.hdns_token != "")
}

module "cluster" {
    source       = "./modules/hcloud_rke2"
    location     = var.location
    domain       = var.domain
    name         = var.cluster_name
    master_type  = var.master_type
    agent_type   = var.agent_type
    agent_count  = var.agent_count
    image        = var.image
    rke2_version = var.rke2_version
}

module "dns" {
    source       = "./modules/hdns"
    count        = local.setup_dns ? 1 : 0
    zone         = var.domain
    cluster_name = var.cluster_name
    lb_ipv4      = module.cluster.lb_ipv4
    lb_ipv6      = module.cluster.lb_ipv6
}

module "ccm" {
    source             = "./modules/hcloud_ccm"
    hcloud_ccm_version = var.hcloud_ccm_version
    hcloud_token       = var.hcloud_token
    network            = module.cluster.network
}

module "csi" {
    source                = "./modules/hcloud_csi"
    count                 = var.use_hcloud_storage ? 1 : 0
    hcloud_csi_version    = var.hcloud_csi_version
    hcloud_secret         = module.ccm.hcloud_secret
    default_storage_class = !var.use_longhorn
}

module "upgrade" {
    depends_on                        = [module.ccm]
    source                            = "./modules/upgrade"
    count                             = var.automated_upgrades ? 1 : 0
    system_upgrade_controller_version = var.system_upgrade_controller_version
    rke2_version                      = var.rke2_version
}

module "cert_manager" {
    depends_on           = [module.ccm]
    source               = "granito-source/cert-manager/kubernetes"
    version              = "~> 0.1.1"
    cert_manager_version = var.cert_manager_version
    acme_email           = var.acme_email
    ingress_class_name   = module.cluster.ingress_class_name
}

module "headlamp" {
    source           = "granito-source/headlamp/kubernetes"
    version          = "~> 0.2.0"
    count            = var.use_headlamp ? 1 : 0
    headlamp_version = var.headlamp_version
    host             = "headlamp.${module.cluster.fqdn}"
    ingress_class    = module.cluster.ingress_class_name
    issuer_name      = module.cert_manager.cluster_issuer
}

module "longhorn" {
    source             = "granito-source/longhorn/kubernetes"
    version            = "~> 0.2.0"
    count              = var.use_longhorn ? 1 : 0
    longhorn_version   = var.longhorn_version
    host               = "longhorn.${module.cluster.fqdn}"
    password           = var.longhorn_password
    ingress_class_name = module.cluster.ingress_class_name
    issuer_name        = module.cert_manager.cluster_issuer
}
