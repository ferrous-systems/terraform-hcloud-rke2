resource "kubernetes_namespace" "longhorn" {
    metadata {
        name = "longhorn-system"
    }
}

resource "random_password" "longhorn" {
    length = 14
}

resource "kubernetes_secret" "longhorn_auth" {
    metadata {
        namespace = kubernetes_namespace.longhorn.metadata[0].name
        name      = "longhorn-auth"
    }
    data = {
        (var.longhorn_user) = random_password.longhorn.bcrypt_hash
    }
}

locals {
    longhorn_host = "longhorn.${var.domain}"
}

resource "helm_release" "longhorn" {
    namespace  = kubernetes_namespace.longhorn.metadata[0].name
    name       = "longhorn"
    repository = "https://charts.longhorn.io"
    chart      = "longhorn"
    version    = var.longhorn_version
    values     = [
        <<-EOT
        defaultSettings:
          deletingConfirmationFlag: true
          allowCollectingLonghornUsageMetrics: false
        longhornUI:
          replicas: 1
        ingress:
          enabled: true
          ingressClassName: nginx
          host: ${local.longhorn_host}
          annotations:
            nginx.ingress.kubernetes.io/auth-type: basic
            nginx.ingress.kubernetes.io/auth-secret: ${kubernetes_secret.longhorn_auth.metadata[0].name}
            nginx.ingress.kubernetes.io/auth-secret-type: auth-map
            nginx.ingress.kubernetes.io/auth-realm: Longhorn
        EOT
    , var.cluster_issuer == null ? "" : <<-EOT
        ingress:
          tls: true
          annotations:
            cert-manager.io/cluster-issuer: ${var.cluster_issuer}
        EOT
    ]
}
