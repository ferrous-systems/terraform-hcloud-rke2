variable "hcloud_token" {
    type        = string
    sensitive   = true
    description = "Hetzner Cloud API token"
}

variable "hdns_token" {
    type        = string
    sensitive   = true
    default     = ""
    description = "Hetzner DNS API token"
}

variable "location" {
    type        = string
    default     = "nbg1"
    description = "Hetzner location"
}

variable "domain" {
    type        = string
    description = "domain of the cluster"
}

variable "cluster_name" {
    type        = string
    description = "name of the cluster"
}

variable "master_type" {
    type        = string
    default     = "cax11"
    description = "machine type to use for the master servers"
}

variable "agent_type" {
    type        = string
    default     = "cax11"
    description = "machine type to use for the agents"
}

variable "agent_count" {
    type        = number
    default     = 0
    description = "count of the agent servers"
}

variable "image" {
    type        = string
    default     = "ubuntu-22.04"
    description = "image to use for the servers"
}

variable "rke2_version" {
    type        = string
    default     = "v1.27.11+rke2r1"
    description = "target version of RKE2"
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

variable "system_upgrade_controller_version" {
    type        = string
    default     = "0.13.4"
    description = "version of the System Upgrade Controller"
}

variable "cert_manager_version" {
    type        = string
    default     = "v1.14.4"
    description = "cert-manager Helm chart version"
}

variable "longhorn_version" {
    type        = string
    default     = "1.5.4"
    description = "Longhorn Helm chart version"
}

variable "headlamp_version" {
    type        = string
    default     = "0.19.0"
    description = "Headlamp Helm chart version"
}

variable "write_config_files" {
    type        = bool
    default     = false
    description = "write SSK private key and client config if true"
}

variable "automated_upgrades" {
    type        = bool
    default     = false
    description = "perform automated upgrades if true; only works with AMD64"
}

variable "acme_email" {
    type        = string
    default     = null
    description = "Let's Encrypt ACME registration e-mail; if set it will create the cluster issuer"
}

variable "use_hcloud_storage" {
    type        = bool
    default     = false
    description = "deploy Hetzner Cloud CSI driver if true"
}

variable "use_longhorn" {
    type        = bool
    default     = false
    description = "deploy Longhorn distributed block storage if true"
}

variable "longhorn_password" {
    type        = string
    default     = null
    sensitive   = true
    description = "password for Longhorn UI"
}

variable "use_headlamp" {
    type        = bool
    default     = false
    description = "deploy Headlamp Kubernetes UI if true"
}
