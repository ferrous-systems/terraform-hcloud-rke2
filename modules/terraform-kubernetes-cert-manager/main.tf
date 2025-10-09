resource "kubernetes_namespace_v1" "cert_manager" {
    metadata {
        name = var.namespace
    }
}

resource "helm_release" "cert_manager" {
    namespace  = kubernetes_namespace_v1.cert_manager.metadata[0].name
    name       = "cert-manager"
    repository = "https://charts.jetstack.io"
    chart      = "cert-manager"
    version    = var.cert_manager_version
    values     = [
        <<-EOT
        crds:
          enabled: true
          keep: ${var.keep_crds}
        replicaCount: ${var.replicas}
        podDisruptionBudget:
            enabled: ${var.replicas > 1 ? "true" : "false"}
        prometheus:
          servicemonitor:
            enabled: ${var.prometheus_service_monitor_enabled}
        EOT
    ]
}
