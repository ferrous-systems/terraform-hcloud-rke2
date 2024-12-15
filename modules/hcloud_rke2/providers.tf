terraform {
    required_providers {
        hcloud = {
            source  = "hetznercloud/hcloud"
            version = ">= 1.46.1"
        }
        remote = {
            source  = "tenstad/remote"
            version = ">= 0.1.3"
        }
    }
}
