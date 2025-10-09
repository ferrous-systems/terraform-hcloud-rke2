output "staging_cluster_issuer" {
    value       = local.create_issuers ? kubectl_manifest.lets_encrypt_staging[0].name : null
    description = "staging cluster issuer name for Let's Encrypt if created"
}

output "cluster_issuer" {
    value       = local.create_issuers ? kubectl_manifest.lets_encrypt[0].name : null
    description = "production cluster issuer name for Let's Encrypt if created"
}
