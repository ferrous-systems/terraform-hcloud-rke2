resource "kubernetes_namespace" "headlamp" {
    metadata {
        name = "headlamp"
    }
}

locals {
    headlamp_host = "headlamp.${var.domain}"
}

resource "helm_release" "headlamp" {
    namespace  = kubernetes_namespace.headlamp.metadata[0].name
    name       = "headlamp"
    repository = "https://headlamp-k8s.github.io/headlamp"
    chart      = "headlamp"
    version    = var.headlamp_version
    values     = [
        <<-EOT
        ingress:
          enabled: true
          annotations:
            kubernetes.io/ingress.class: nginx
          hosts:
            - host: ${local.headlamp_host}
              paths:
                - path: /
                  type: Prefix
        EOT
    , var.cluster_issuer == null ? "" : <<-EOT
        ingress:
          annotations:
            cert-manager.io/cluster-issuer: ${var.cluster_issuer}
          tls:
            - secretName: headlamp-tls
              hosts:
                - ${local.headlamp_host}
        EOT
    ]
}
