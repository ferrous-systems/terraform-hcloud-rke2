resource "helm_release" "hcloud_csi" {
    namespace  = "kube-system"
    name       = "hcloud-csi"
    repository = "https://charts.hetzner.cloud"
    chart      = "hcloud-csi"
    version    = var.hcloud_csi_version
    values     = [
        <<-EOT
        controller:
          hcloudToken:
            existingSecret:
              name: ${var.hcloud_secret}
              key: token
        storageClasses:
          - name: ${var.hcloud_storage_class}
            defaultStorageClass: ${var.default_storage_class}
            reclaimPolicy: Delete
        EOT
    ]
}
