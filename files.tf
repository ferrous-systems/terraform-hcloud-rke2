resource "local_file" "ssh_key" {
    content         = module.cluster.ssh_private_key
    filename        = "id_rsa_${var.cluster_name}"
    file_permission = "0600"
}

locals {
    api_url = "https://${local.setup_dns ? module.cluster.api : module.cluster.lb_ipv4}:6443"
}

resource "local_file" "kubeconfig" {
    filename        = "config-${var.cluster_name}.yaml"
    file_permission = "0600"
    content         = <<-EOT
    apiVersion: v1
    kind: Config
    clusters:
    - cluster:
        certificate-authority-data: ${module.cluster.cluster_ca_certificate}
        server: ${local.api_url}
      name: ${var.cluster_name}
    contexts:
    - context:
        cluster: ${var.cluster_name}
        namespace: kube-system
        user: ${var.cluster_name}-system:admin
      name: ${var.cluster_name}-system:admin
    current-context: ${var.cluster_name}-system:admin
    preferences: {}
    users:
    - name: ${var.cluster_name}-system:admin
      user:
        client-certificate-data: ${module.cluster.client_certificate}
        client-key-data: ${module.cluster.client_key}
    EOT
}
