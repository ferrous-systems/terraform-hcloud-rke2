resource "kubernetes_namespace" "headlamp" {
    count = var.headlamp_version != null ? 1 : 0
    metadata {
        name = "headlamp"
    }
}

locals {
    headlamp_host = "headlamp.${var.fqdn}"
}

resource "helm_release" "headlamp" {
    count      = var.headlamp_version != null ? 1 : 0
    depends_on = [kubectl_manifest.lets_encrypt]
    namespace  = kubernetes_namespace.headlamp[count.index].metadata[0].name
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
    , !local.configure_issuer ? "" : <<-EOT
        ingress:
          annotations:
            cert-manager.io/cluster-issuer: lets-encrypt
          tls:
            - secretName: headlamp-tls
              hosts:
                - ${local.headlamp_host}
        EOT
    ]
}
