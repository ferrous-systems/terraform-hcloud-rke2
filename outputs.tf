output "api_url" {
  value = local.api_url
}

output "lb_ipv4" {
  value = module.cluster.lb_ipv4
}

output "lb_ipv6" {
  value = module.cluster.lb_ipv6
}

output "master" {
  value = module.cluster.master
}

output "agent" {
  value = module.cluster.agent
}

output "ssh_private_key" {
  value     = module.cluster.ssh_private_key
  sensitive = true
}

output "kubeconfig" {
  value     = local.kubeconfig
  sensitive = true
}

output "headlamp_url" {
  value = var.use_headlamp ? module.headlamp[0].url : null
}

output "longhorn_url" {
  value = var.use_longhorn ? module.longhorn[0].url : null
}
