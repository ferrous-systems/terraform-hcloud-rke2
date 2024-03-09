resource "kubernetes_namespace" "headlamp" {
    metadata {
        name = "headlamp"
    }
    lifecycle {
        ignore_changes = [metadata[0].annotations]
    }
}

resource "helm_release" "headlamp" {
    depends_on = [
        kubernetes_namespace.headlamp,
        kubernetes_manifest.cluster_issuer
    ]
    namespace  = "headlamp"
    name       = "headlamp"
    repository = "https://headlamp-k8s.github.io/headlamp/"
    chart      = "headlamp"
    version    = var.headlamp_version
    values     = [
        <<-EOT
        ingress:
          enabled: true
          annotations:
            kubernetes.io/ingress.class: nginx
            cert-manager.io/cluster-issuer: lets-encrypt
          hosts:
            - host: headlamp.${var.fqdn}
              paths:
                - path: /
                  type: Prefix
          tls:
            - secretName: headlamp-tls
              hosts:
                - headlamp.${var.fqdn}
        EOT
    ]
}
