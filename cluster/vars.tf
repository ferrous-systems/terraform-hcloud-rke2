variable "domain" {
    type        = string
    description = "domain of the cluster"
}

variable "cluster_name" {
    type        = string
    description = "name of the cluster"
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

variable "network" {
    type        = string
    default     = "10.0.0.0/8"
    description = "network to use"
}

variable "subnet" {
    type        = string
    default     = "10.110.0.0/16"
    description = "subnet to use"
}

variable "lb_type" {
    type        = string
    default     = "lb11"
    description = "load balancer type"
}

variable "lb_ip" {
    type        = string
    default     = "10.110.0.1"
    description = "IP to use for control plane load balancer"
}

variable "rke2_version" {
    type        = string
    default     = ""
    description = "version of RKE2 to install"
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
    type        = string
    default     = "ubuntu-22.04"
    description = "image to use for the servers"
}
