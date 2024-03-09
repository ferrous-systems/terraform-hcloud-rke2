resource "kubernetes_secret" "hcloud" {
    metadata {
        namespace = "kube-system"
        name      = "hcloud"
    }
    data = {
        token   = var.hcloud_token
        network = var.network
    }
    lifecycle {
        ignore_changes = [metadata[0].annotations]
    }
}

resource "helm_release" "hcloud-ccm" {
    depends_on = [kubernetes_secret.hcloud]
    namespace  = "kube-system"
    name       = "hcloud-ccm"
    repository = "https://charts.hetzner.cloud"
    chart      = "hcloud-cloud-controller-manager"
    version    = var.hcloud_ccm_version
    set {
        name  = "networking.enabled"
        value = true
    }
}

resource "helm_release" "hcloud-csi" {
    depends_on = [helm_release.hcloud-ccm]
    namespace  = "kube-system"
    name       = "hcloud-csi"
    repository = "https://charts.hetzner.cloud"
    chart      = "hcloud-csi"
    version    = var.hcloud_csi_version
}
