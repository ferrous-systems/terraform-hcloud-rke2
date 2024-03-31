resource "local_file" "ssh_key" {
    count           = var.write_config_files ? 1 : 0
    content         = module.cluster.ssh_private_key
    filename        = "id_rsa_${var.cluster_name}"
    file_permission = "0600"
}

locals {
    api_url    = "https://${local.setup_dns ? module.cluster.api : module.cluster.lb_ipv4}:6443"
    kubeconfig = <<-EOT
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
        user: system:admin@${var.cluster_name}
      name: system:admin@${var.cluster_name}
    current-context: system:admin@${var.cluster_name}
    preferences: {}
    users:
    - name: system:admin@${var.cluster_name}
      user:
        client-certificate-data: ${module.cluster.client_certificate}
        client-key-data: ${module.cluster.client_key}
    EOT
}

resource "local_file" "kubeconfig" {
    count           = var.write_config_files ? 1 : 0
    filename        = "config-${var.cluster_name}.yaml"
    file_permission = "0600"
    content         = local.kubeconfig
}
