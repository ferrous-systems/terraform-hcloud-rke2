output "cluster_issuer" {
    value = local.create ? kubectl_manifest.lets_encrypt[0].name : null
}
