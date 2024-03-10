output "storage_class" {
    depends_on = [helm_release.hcloud-csi]
    value      = local.storage_class
}
