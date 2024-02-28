variable "hcloud_token" {
    type        = string
    sensitive   = true
    description = "Hetzner Cloud API token"
}

variable "clustername" {
    type        = string
    description = "name of the cluster"
}

variable "domains" {
    type        = list(string)
    description = "list of cluster domains"
}

variable "location" {
    type        = string
    default     = "nbg1"
    description = "Hetzner location"
}

variable "networkzone" {
    type        = string
    default     = "eu-central"
    description = "Hetzner network zone"
}

variable "network" {
    type        = string
    default     = "10.0.0.0/8"
    description = "network to use"
}

variable "subnet" {
    type        = string
    default     = "10.110.21.0/24"
    description = "subnet to use"
}

variable "lb_type" {
    type        = string
    default     = "lb11"
    description = "load balancer type"
}

variable "internalbalancerip" {
    type        = string
    default     = "10.110.21.2"
    description = "IP to use for control plane load balancer"
}

variable "rke2_version" {
    type        = string
    default     = ""
    description = "version of RKE2 to install"
}

variable "rke2_cluster_secret" {
    type        = string
    description = "cluster secret for RKE2 cluster registration"
}

variable "extra_ssh_keys" {
    type        = list(string)
    default     = []
    description = "extra SSH keys to inject into servers"
}

variable "master_type" {
    type        = string
    default     = "cx21"
    description = "machine type to use for the master servers"
}

variable "master_count" {
    type        = number
    default     = 3
    description = "count of the master servers"
}

variable "agent_type" {
    type        = string
    default     = "cx21"
    description = "machine type to use for the agents"
}

variable "agent_count" {
    type        = number
    default     = 0
    description = "count of the agent servers"
}

variable "image" {
    type = string
    default = "ubuntu-22.04"
    description = "image to use for the servers"
}
