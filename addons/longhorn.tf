resource "kubernetes_namespace" "longhorn" {
    count = var.longhorn_version != null ? 1 : 0
    metadata {
        name = "longhorn-system"
    }
}

resource "random_password" "longhorn" {
    count  = var.longhorn_version != null ? 1 : 0
    length = 14
}

resource "kubernetes_secret" "longhorn_auth" {
    count = var.longhorn_version != null ? 1 : 0
    metadata {
        namespace = kubernetes_namespace.longhorn[count.index].metadata[0].name
        name      = "longhorn-auth"
    }
    data = {
        (var.longhorn_user) = random_password.longhorn[count.index].bcrypt_hash
    }
}

locals {
    longhorn_host = "longhorn.${var.fqdn}"
}

resource "helm_release" "longhorn" {
    count      = var.longhorn_version != null ? 1 : 0
    depends_on = [kubectl_manifest.lets_encrypt]
    namespace  = kubernetes_namespace.longhorn[count.index].metadata[0].name
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
            nginx.ingress.kubernetes.io/auth-secret: ${kubernetes_secret.longhorn_auth[count.index].metadata[0].name}
            nginx.ingress.kubernetes.io/auth-secret-type: auth-map
            nginx.ingress.kubernetes.io/auth-realm: Longhorn
        EOT
    , !local.configure_issuer ? "" : <<-EOT
        ingress:
          tls: true
          annotations:
            cert-manager.io/cluster-issuer: lets-encrypt
        EOT
    ]
}
