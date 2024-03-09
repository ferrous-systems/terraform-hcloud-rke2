resource "kubernetes_manifest" "lets_encrypt" {
    depends_on = [helm_release.cert_manager]
    manifest   = {
        apiVersion = "cert-manager.io/v1"
        kind       = "ClusterIssuer"
        metadata   = {
            name = "lets-encrypt"
        }
        spec = {
            acme = {
                email               = var.acme_email
                privateKeySecretRef = {
                    name = "lets-encrypt"
                }
                server  = "https://acme-v02.api.letsencrypt.org/directory"
                solvers = [
                    {
                        http01 = {
                            ingress = {
                                ingressClassName = "nginx"
                            }
                        }
                    }
                ]
            }
        }
    }
}
