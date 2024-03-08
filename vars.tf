variable "hcloud_token" {
    type        = string
    sensitive   = true
    description = "Hetzner Cloud API token"
}

variable "hdns_token" {
    type        = string
    sensitive   = true
    description = "Hetzner DNS API token"
}

variable "network_zone" {
    type        = string
    default     = "eu-central"
    description = "Hetzner network zone"
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

variable "agent_count" {
    type        = number
    default     = 0
    description = "count of the agent servers"
}

variable "acme_email" {
    type    = string
    default = "Let's Encrypt ACME registration e-mail"
}
