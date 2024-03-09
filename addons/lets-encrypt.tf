resource "kubectl_manifest" "lets_encrypt" {
    depends_on = [helm_release.cert_manager]
    yaml_body  = <<-EOT
    apiVersion: cert-manager.io/v1
    kind: ClusterIssuer
    metadata:
      name: lets-encrypt
    spec:
      acme:
        server: https://acme-v02.api.letsencrypt.org/directory
        privateKeySecretRef:
          name: lets-encrypt
        solvers:
          - http01:
              ingress:
                ingressClassName: nginx
    EOT
}
