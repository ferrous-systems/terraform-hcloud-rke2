data "hetznerdns_zone" "zone" {
    name = var.domain
}

resource "hetznerdns_record" "wildcard_ipv4" {
    zone_id = data.hetznerdns_zone.zone.id
    name    = "*.${var.cluster_name}"
    value   = var.lb_ipv4
    type    = "A"
    ttl     = 300
}

resource "hetznerdns_record" "wildcard_ipv6" {
    zone_id = data.hetznerdns_zone.zone.id
    name    = "*.${var.cluster_name}"
    value   = var.lb_ipv6
    type    = "AAAA"
    ttl     = 300
}
