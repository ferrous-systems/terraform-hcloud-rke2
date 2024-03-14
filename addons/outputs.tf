output "longhorn_storage_class" {
    depends_on = [helm_release.longhorn]
    value      = var.longhorn_version != null ? "longhorn" : null
}

output "longhorn_password" {
    depends_on = [helm_release.longhorn]
    value      = var.longhorn_version != null ? random_password.longhorn[0].result : null
    sensitive  = true
}
