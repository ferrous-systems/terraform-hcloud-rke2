output "hcloud_secret" {
  value = kubernetes_secret.hcloud.metadata[0].name
}
