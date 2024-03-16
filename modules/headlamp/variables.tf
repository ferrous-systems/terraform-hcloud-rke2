variable "domain" {
    type        = string
    description = "cluster domain"
}

variable "cluster_issuer" {
    type        = string
    description = "cert-manager cluster issuer"
}

variable "headlamp_version" {
    type        = string
    description = "Headlamp Helm chart version"
}
