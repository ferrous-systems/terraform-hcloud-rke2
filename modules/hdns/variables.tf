variable "zone" {
  type        = string
  description = "DNS zone for the cluster"
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

variable "ttl" {
  type        = number
  default     = 300
  description = "TTL of the cluster wildcard records"
}
