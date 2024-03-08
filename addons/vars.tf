variable "cert_manager_version" {
    type        = string
    default     = "v1.14.4"
    description = "cert-manager version"
}

variable "acme_email" {
    type    = string
    default = "Let's Encrypt ACME registration e-mail"
}
