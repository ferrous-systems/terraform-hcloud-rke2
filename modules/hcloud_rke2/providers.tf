terraform {
    required_providers {
        hcloud = {
            source  = "hetznercloud/hcloud"
            version = "~> 1.45.0"
        }
        remote = {
            source  = "tenstad/remote"
            version = "~> 0.1.2"
        }
    }
}
