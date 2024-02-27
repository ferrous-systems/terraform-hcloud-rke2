variable "ssh_keys" {
    type        = list(string)
    description = "SSH key names"
}

variable "clustername" {
    type        = string
    description = "name of the cluster"
}

variable "domains" {
    type        = list(string)
    description = "list of cluster domains"
}

variable "master_count" {
    default     = 3
    description = "count of RKE2 master servers"
}

variable "master_type" {
    type        = string
    default     = "cx21"
    description = "machine type to use for the masters"
}

variable "extra_ssh_keys" {
    type        = list(string)
    default     = []
    description = "extra SSH keys to inject into Rancher instances"
}

variable "rke2_cluster_secret" {
    type        = string
    description = "cluster secret for RKE2 cluster registration"
}

variable "rke2_version" {
    type        = string
    default     = ""
    description = "version of RKE2 to install"
}

variable "location" {
    type        = string
    default     = "nbg1"
    description = "Hetzner location"
}

variable "lb_ip" {
    type        = string
    description = "IP of the LB to use to connect masters"
}

variable "lb_external_v4" {
    type        = string
    description = "external v4 IP of the LB"
}

variable "lb_external_v6" {
    type        = string
    description = "external v4 IP of the LB"
}

variable "lb_id" {
    type        = string
    description = "ID of the load balancer to connect masters"
}

variable "network_id" {
    type        = string
    description = "network ID to put servers into"
}

variable "api_token" {
    type        = string
    description = "Hetzner API token with read permission to read LB state"
}
