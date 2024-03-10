resource "kubernetes_namespace" "longhorn" {
    metadata {
        name = "longhorn-system"
    }
}

resource "helm_release" "longhorn" {
    depends_on = [kubectl_manifest.lets_encrypt]
    namespace  = kubernetes_namespace.longhorn.metadata[0].name
    name       = "longhorn"
    repository = "https://charts.longhorn.io"
    chart      = "longhorn"
    version    = var.longhorn_version
    values     = [
        <<-EOT
        longhornUI:
          replicas: 1
        ingress:
          enabled: false
          ingressClassName: nginx
          host: longhorn.${var.fqdn}
          tls: true
          annotations:
            cert-manager.io/cluster-issuer: lets-encrypt
        EOT
    ]
}
