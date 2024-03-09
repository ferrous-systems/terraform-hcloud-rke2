resource "kubernetes_namespace" "cert_manager" {
    metadata {
        name = "cert-manager"
    }
    lifecycle {
        ignore_changes = [metadata[0].annotations]
    }
}

resource "helm_release" "cert_manager" {
    depends_on = [kubernetes_namespace.cert_manager]
    namespace  = "cert-manager"
    name       = "cert-manager"
    repository = "https://charts.jetstack.io"
    chart      = "cert-manager"
    version    = var.cert_manager_version
    set {
        name  = "installCRDs"
        value = "true"
    }
}

#resource "kubernetes_manifest" "cluster_issuer" {
#    depends_on = [helm_release.cert_manager]
#    manifest   = {
#        apiVersion = "cert-manager.io/v1"
#        kind       = "ClusterIssuer"
#        metadata   = {
#            name = "lets-encrypt"
#        }
#        spec = {
#            acme = {
#                email               = var.acme_email
#                privateKeySecretRef = {
#                    name = "lets-encrypt"
#                }
#                server  = "https://acme-v02.api.letsencrypt.org/directory"
#                solvers = [
#                    {
#                        http01 = {
#                            ingress = {
#                                ingressClassName = "nginx"
#                            }
#                        }
#                    }
#                ]
#            }
#        }
#    }
#}
