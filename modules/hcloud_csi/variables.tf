variable "hcloud_secret" {
    type        = string
    description = "name of the secret containing Hetzner Cloud API token"
}

variable "hcloud_csi_version" {
    type        = string
    default     = null
    description = "Hetzner Cloud CSI driver version"
}

variable "hcloud_storage_class" {
    type        = string
    default     = "hcloud"
    description = "storage class for Hetzner Cloud volumes"
}

variable "default_storage_class" {
    type        = bool
    description = "make Hetzner Cloud storage class default if true"
}
