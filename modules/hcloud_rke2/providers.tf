terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = ">= 1.52.0"
    }
    remote = {
      source  = "tenstad/remote"
      version = ">= 0.2.1"
    }
  }
}
