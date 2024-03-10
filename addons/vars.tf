variable "fqdn" {
    type        = string
    description = "cluster FQDN"
}

variable "cert_manager_version" {
    type        = string
    default     = "v1.14.4"
    description = "cert-manager Helm chart version"
}

variable "acme_email" {
    type    = string
    default = "Let's Encrypt ACME registration e-mail"
}

variable "longhorn_version" {
    type        = string
    default     = "1.5.4"
    description = "Longhorn Helm chart version"
}

variable "headlamp_version" {
    type        = string
    default     = "0.19.0"
    description = "Headlamp Helm chart version"
}
