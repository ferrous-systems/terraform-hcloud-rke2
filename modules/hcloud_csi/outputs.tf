output "storage_class" {
  depends_on = [helm_release.hcloud_csi]
  value      = var.hcloud_storage_class
}
