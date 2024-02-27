variable "clustername" {
    type        = string
    description = "name of the cluster"
}

variable "network" {
    type        = string
    default     = "10.0.0.0/8"
    description = "network to use"
}

variable "subnetwork" {
    type        = string
    default     = "10.0.0.0/24"
    description = "subnetwork to use"
}

variable "networkzone" {
    type        = string
    default     = "eu-central"
    description = "Hetzner network zone"
}

variable "internalbalancerip" {
    type        = string
    default     = "10.0.0.2"
    description = "IP to use for control plane load balancer"
}

variable "lb_type" {
    type        = string
    default     = "lb11"
    description = "load balancer type"
}
