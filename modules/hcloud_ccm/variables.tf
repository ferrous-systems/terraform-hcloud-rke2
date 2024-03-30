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
    default     = null
    description = "Cloud Controller Manager for Hetzner Cloud version"
}
