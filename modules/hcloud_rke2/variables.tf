variable "domain" {
    type        = string
    description = "domain of the cluster"
}

variable "name" {
    type        = string
    description = "name of the cluster"
}

variable "location" {
    type        = string
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
    description = "IP to use for the cluster load balancer"
}

variable "rke2_version" {
    type        = string
    default     = ""
    description = "version of RKE2 to install"
}

variable "master_type" {
    type        = string
    description = "machine type to use for the master servers"
}

variable "agent_type" {
    type        = string
    description = "machine type to use for the agents"
}

variable "agent_count" {
    type        = number
    description = "count of the agent servers"
}

variable "image" {
    type        = string
    description = "image to use for the servers"
}
