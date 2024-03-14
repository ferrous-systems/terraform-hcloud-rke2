variable "hcloud_token" {
    type        = string
    sensitive   = true
    description = "Hetzner Cloud API token"
}

variable "network" {
    type        = string
    description = "private cluster network name"
}

variable "hcloud_ccm_version" {
    type        = string
    description = "Cloud Controller Manager for Hetzner Cloud version"
}

variable "hcloud_csi_version" {
    type        = string
    description = "Hetzner Cloud CSI driver version"
}

variable "hcloud_storage_class" {
    type        = string
    default     = "hcloud"
    description = "storage class for Hetzner Cloud volumes"
}
