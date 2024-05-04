terraform {
    required_providers {
        hcloud = {
            source  = "hetznercloud/hcloud"
            version = "~> 1.47.0"
        }
        hetznerdns = {
            source  = "timohirt/hetznerdns"
            version = "~> 2.2.0"
        }
        kubectl = {
            source  = "gavinbunney/kubectl"
            version = "~> 1.14.0"
        }
        remote = {
            source  = "tenstad/remote"
            version = "~> 0.1.3"
        }
    }
}

provider "hcloud" {
    token = var.hcloud_token
}

provider "hetznerdns" {
    apitoken = var.hdns_token
}

resource "terraform_data" "cluster_api_url" {
    input = "https://${module.cluster.lb_ipv4}:6443"
}

resource "terraform_data" "cluster_ca_certificate" {
    input = base64decode(module.cluster.cluster_ca_certificate)
}

resource "terraform_data" "client_certificate" {
    input = base64decode(module.cluster.client_certificate)
}

resource "terraform_data" "client_key" {
    input = base64decode(module.cluster.client_key)
}

provider "kubernetes" {
    host                   = terraform_data.cluster_api_url.output
    cluster_ca_certificate = terraform_data.cluster_ca_certificate.output
    client_certificate     = terraform_data.client_certificate.output
    client_key             = terraform_data.client_key.output
}

provider "kubectl" {
    host                   = terraform_data.cluster_api_url.output
    cluster_ca_certificate = terraform_data.cluster_ca_certificate.output
    client_certificate     = terraform_data.client_certificate.output
    client_key             = terraform_data.client_key.output
}

provider "helm" {
    kubernetes {
        host                   = terraform_data.cluster_api_url.output
        cluster_ca_certificate = terraform_data.cluster_ca_certificate.output
        client_certificate     = terraform_data.client_certificate.output
        client_key             = terraform_data.client_key.output
    }
}
