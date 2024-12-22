data "hetznerdns_zone" "cluster" {
  name = var.zone
}

resource "hetznerdns_record" "wildcard_ipv4" {
  zone_id = data.hetznerdns_zone.cluster.id
  name    = "*.${var.cluster_name}"
  value   = var.lb_ipv4
  type    = "A"
  ttl     = var.ttl
}

resource "hetznerdns_record" "wildcard_ipv6" {
  zone_id = data.hetznerdns_zone.cluster.id
  name    = "*.${var.cluster_name}"
  value   = var.lb_ipv6
  type    = "AAAA"
  ttl     = var.ttl
}
