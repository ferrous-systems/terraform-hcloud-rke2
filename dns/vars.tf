variable "domain" {
    type        = string
    description = "domain of the cluster"
}

variable "cluster_name" {
    type        = string
    description = "name of the cluster"
}

variable "lb_ipv4" {
    type        = string
    description = "IPv4 address of the load balancer"
}

variable "lb_ipv6" {
    type        = string
    description = "IPv6 address of the load balancer"
}

variable "server" {
    type = map(object({
        ipv4_address = string
        ipv6_address = string
    }))
    description = "nodes of the cluster"
}
