locals {
    create_issuers = var.acme_email != null
    ingress_class  = var.ingress_class == null ? "null" : var.ingress_class
}

resource "kubectl_manifest" "lets_encrypt_staging" {
    count      = local.create_issuers ? 1 : 0
    depends_on = [helm_release.cert_manager]
    yaml_body  = <<-EOT
    apiVersion: cert-manager.io/v1
    kind: ClusterIssuer
    metadata:
      name: lets-encrypt-staging
    spec:
      acme:
        server: https://acme-staging-v02.api.letsencrypt.org/directory
        email: ${var.acme_email}
        privateKeySecretRef:
          name: lets-encrypt-staging
        solvers:
          - http01:
              ingress:
                ingressClassName: ${local.ingress_class}
    EOT
}

resource "kubectl_manifest" "lets_encrypt" {
    count      = local.create_issuers ? 1 : 0
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
                ingressClassName: ${local.ingress_class}
    EOT
}
