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

#output "kubeconfig" {
#    value = module.cluster.kubeconfig
#}
