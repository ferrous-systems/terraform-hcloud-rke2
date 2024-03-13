data "hetznerdns_zone" "zone" {
    count = var.setup_dns ? 1 : 0
    name  = var.domain
}

resource "hetznerdns_record" "wildcard_ipv4" {
    count   = var.setup_dns ? 1 : 0
    zone_id = data.hetznerdns_zone.zone[0].id
    name    = "*.${var.cluster_name}"
    value   = var.lb_ipv4
    type    = "A"
    ttl     = 300
}

resource "hetznerdns_record" "wildcard_ipv6" {
    count   = var.setup_dns ? 1 : 0
    zone_id = data.hetznerdns_zone.zone[0].id
    name    = "*.${var.cluster_name}"
    value   = var.lb_ipv6
    type    = "AAAA"
    ttl     = 300
}
