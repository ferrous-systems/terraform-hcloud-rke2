variable "cert_manager_version" {
    type        = string
    description = "cert-manager Helm chart version"
}

variable "acme_ingress_class" {
    type        = string
    default     = "nginx"
    description = "ingress class name for ACME HTTP01 solver"
}

variable "acme_email" {
    type        = string
    description = "Let's Encrypt ACME registration e-mail"
}
