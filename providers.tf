terraform {
    required_providers {
        hcloud = {
            source  = "hetznercloud/hcloud"
            version = ">= 1.45.0"
        }
        hetznerdns = {
            source  = "timohirt/hetznerdns"
            version = ">= 2.2.0"
        }
        kubectl = {
            source  = "gavinbunney/kubectl"
            version = ">= 1.14.0"
        }
    }
}

provider "hcloud" {
    token = var.hcloud_token
}

provider "hetznerdns" {
    apitoken = var.hdns_token
}

locals {
    cluster_api_url        = "https://${module.cluster.lb_ipv4}:6443"
    cluster_ca_certificate = base64decode(module.cluster.cluster_ca_certificate)
    client_certificate     = base64decode(module.cluster.client_certificate)
    client_key             = base64decode(module.cluster.client_key)
}

provider "kubernetes" {
    host                   = local.cluster_api_url
    cluster_ca_certificate = local.cluster_ca_certificate
    client_certificate     = local.client_certificate
    client_key             = local.client_key
}

provider "kubectl" {
    host                   = local.cluster_api_url
    cluster_ca_certificate = local.cluster_ca_certificate
    client_certificate     = local.client_certificate
    client_key             = local.client_key
}

provider "helm" {
    kubernetes {
        host                   = local.cluster_api_url
        cluster_ca_certificate = local.cluster_ca_certificate
        client_certificate     = local.client_certificate
        client_key             = local.client_key
    }
}
