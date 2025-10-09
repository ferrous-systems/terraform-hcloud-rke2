variable "namespace" {
    type        = string
    default     = "cert-manager"
    description = "namespace to use for the installation"
}

variable "cert_manager_version" {
    type        = string
    default     = null
    description = "override cert-manager Helm chart version"
}

variable "keep_crds" {
    type        = bool
    default     = true
    description = "control the retention of the CRDs after the removal of the chart"
}

variable "replicas" {
    type        = number
    default     = 1
    description = "the number of replicas of the cert-manager controller to run"
}

variable "ingress_class" {
    type        = string
    default     = null
    description = "ingress class name for ACME HTTP01 solver"
}

variable "acme_email" {
    type        = string
    default     = null
    description = "Let's Encrypt ACME registration e-mail, create issuers if not null"
}

variable "prometheus_service_monitor_enabled" {
    type        = bool
    default     = false
    description = "Enable prometheus service monitor"
}