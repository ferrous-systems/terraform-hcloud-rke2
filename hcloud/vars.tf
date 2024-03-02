variable "hcloud_token" {
    type        = string
    sensitive   = true
    description = "Hetzner Cloud API token"
}

variable "network" {
    type    = string
    description = "private cluster network name"
}

variable "hcloud_ccm_version" {
    type        = string
    default     = "1.19.0"
    description = "Cloud Controller Manager for Hetzner Cloud version"
}

variable "hcloud_csi_version" {
    type        = string
    default     = "2.6.0"
    description = "Hetzner Cloud CSI driver version"
}
