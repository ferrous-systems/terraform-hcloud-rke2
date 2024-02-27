variable "ssh_keys" {
    type        = list(string)
    description = "SSH key names"
}

variable "clustername" {
    type        = string
    description = "name of the cluster"
}

variable "agent_count" {
    default     = 3
    description = "count of RKE2 agent servers"
}

variable "agent_type" {
    type        = string
    default     = "cx21"
    description = "machine type to use for the agents"
}

variable "extra_ssh_keys" {
    type        = list(string)
    default     = []
    description = "Extra SSH keys to inject into Rancher instances"
}

variable "rke2_cluster_secret" {
    type        = string
    description = "cluster secret for RKE2 cluster registration"
}

variable "rke2_version" {
    type        = string
    default     = ""
    description = "Version of rke2 to install"
}

variable "location" {
    type        = string
    default     = "nbg1"
    description = "Hetzner location"
}

variable "lb_ip" {
    type        = string
    description = "IP of the LB to use to connect agents"
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
