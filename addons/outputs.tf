output "longhorn_storage_class" {
    depends_on = [helm_release.longhorn]
    value      = "longhorn"
}

output "longhorn_password" {
    depends_on = [helm_release.longhorn]
    value      = random_password.longhorn.result
    sensitive  = true
}
