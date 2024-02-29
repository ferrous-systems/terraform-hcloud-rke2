data "hetznerdns_zone" "zone" {
    name = var.domain
}

resource "hetznerdns_record" "api_ipv4" {
    zone_id = data.hetznerdns_zone.zone.id
    name    = "api.${var.cluster_name}"
    value   = var.lb_ipv4
    type    = "A"
    ttl     = 300
}

resource "hetznerdns_record" "api_ipv6" {
    zone_id = data.hetznerdns_zone.zone.id
    name    = "api.${var.cluster_name}"
    value   = var.lb_ipv6
    type    = "AAAA"
    ttl     = 300
}

resource "hetznerdns_record" "apps_ipv4" {
    zone_id = data.hetznerdns_zone.zone.id
    name    = "*.apps.${var.cluster_name}"
    value   = var.lb_ipv4
    type    = "A"
    ttl     = 300
}

resource "hetznerdns_record" "apps_ipv6" {
    zone_id = data.hetznerdns_zone.zone.id
    name    = "*.apps.${var.cluster_name}"
    value   = var.lb_ipv6
    type    = "AAAA"
    ttl     = 300
}

resource "hetznerdns_record" "server_ipv4" {
    for_each = var.server
    zone_id  = data.hetznerdns_zone.zone.id
    name     = "${each.key}.${var.cluster_name}"
    value    = each.value.ipv4_address
    type     = "A"
    ttl      = 300
}

resource "hetznerdns_record" "server_ipv6" {
    for_each = var.server
    zone_id  = data.hetznerdns_zone.zone.id
    name     = "${each.key}.${var.cluster_name}"
    value    = each.value.ipv6_address
    type     = "AAAA"
    ttl      = 300
}
