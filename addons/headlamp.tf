resource "kubernetes_namespace" "headlamp" {
    metadata {
        name = "headlamp"
    }
}

resource "helm_release" "headlamp" {
    depends_on = [kubectl_manifest.lets_encrypt]
    namespace  = kubernetes_namespace.headlamp.metadata[0].name
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
