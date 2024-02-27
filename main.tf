module "cluster" {
    source       = "./cluster"
    clustername  = var.clustername
    domains      = [var.domain]
    hcloud_token = var.hcloud_token
    rke2_cluster_secret = var.rke2_cluster_secret
}
