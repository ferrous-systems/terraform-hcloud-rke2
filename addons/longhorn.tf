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

resource "helm_release" "longhorn" {
    depends_on = [kubectl_manifest.lets_encrypt]
    namespace  = kubernetes_namespace.longhorn.metadata[0].name
    name       = "longhorn"
    repository = "https://charts.longhorn.io"
    chart      = "longhorn"
    version    = var.longhorn_version
    values     = [
        <<-EOT
        defaultSettings:
          deletingConfirmationFlag: true
        longhornUI:
          replicas: 1
        ingress:
          enabled: true
          ingressClassName: nginx
          host: longhorn.${var.fqdn}
          tls: true
          annotations:
            cert-manager.io/cluster-issuer: lets-encrypt
            nginx.ingress.kubernetes.io/auth-type: basic
            nginx.ingress.kubernetes.io/auth-secret: ${kubernetes_secret.longhorn_auth.metadata[0].name}
            nginx.ingress.kubernetes.io/auth-secret-type: auth-map
            nginx.ingress.kubernetes.io/auth-realm: 'Longhorn Authentication Required'
       EOT
    ]
}
