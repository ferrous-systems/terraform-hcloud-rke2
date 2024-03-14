locals {
    configure_issuer = var.acme_email != ""
}

resource "kubectl_manifest" "lets_encrypt" {
    count      = local.configure_issuer ? 1 : 0
    depends_on = [helm_release.cert_manager]
    yaml_body  = <<-EOT
    apiVersion: cert-manager.io/v1
    kind: ClusterIssuer
    metadata:
      name: lets-encrypt
    spec:
      acme:
        server: https://acme-v02.api.letsencrypt.org/directory
        email: ${var.acme_email}
        privateKeySecretRef:
          name: lets-encrypt
        solvers:
          - http01:
              ingress:
                ingressClassName: nginx
    EOT
}
