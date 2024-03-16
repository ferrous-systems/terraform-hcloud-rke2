variable "domain" {
    type        = string
    description = "cluster domain"
}

variable "cluster_issuer" {
    type        = string
    description = "cert-manager cluster issuer"
}

variable "longhorn_version" {
    type        = string
    description = "Longhorn Helm chart version"
}

variable "longhorn_user" {
    type        = string
    default     = "longhorn"
    description = "Longhorn UI user"
}
