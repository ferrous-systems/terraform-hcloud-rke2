resource "kubernetes_namespace" "cert_manager" {
    metadata {
        name = "cert-manager"
    }
    lifecycle {
        ignore_changes = [metadata[0].annotations]
    }
}

resource "helm_release" "cert_manager" {
    depends_on = [kubernetes_namespace.cert_manager]
    namespace  = "cert-manager"
    name       = "cert-manager"
    repository = "https://charts.jetstack.io"
    chart      = "cert-manager"
    version    = var.cert_manager_version
    set {
        name  = "installCRDs"
        value = "true"
    }
}
