locals {
    node_ids = concat(
        [
            hcloud_server.master0.id,
            hcloud_server.master1.id,
            hcloud_server.master2.id
        ],
        [for a in hcloud_server.agent : a.id]
    )
    internal_ips = concat(
        [
            var.network,
            hcloud_server.master0.ipv4_address,
            hcloud_server.master1.ipv4_address,
            hcloud_server.master2.ipv4_address
        ],
        [for a in hcloud_server.agent : a.ipv4_address]
    )
}

resource "hcloud_firewall" "cluster" {
    name = var.name
    labels = {
        cluster = var.name
    }
    rule {
        description = "Allow ICMP between servers and on internal network"
        direction   = "in"
        protocol    = "icmp"
        source_ips  = local.internal_ips
    }
    rule {
        description = "Allow TCP between servers and on internal network"
        direction   = "in"
        protocol    = "tcp"
        port        = "any"
        source_ips  = local.internal_ips
    }
    rule {
        description = "Allow UDP between servers and on internal network"
        direction   = "in"
        protocol    = "udp"
        port        = "any"
        source_ips  = local.internal_ips
    }
    rule {
        description = "Allow SSH in"
        direction   = "in"
        protocol    = "tcp"
        port        = "22"
        source_ips = ["0.0.0.0/0", "::/0"]
    }
    rule {
        description = "Allow HTTP in"
        direction   = "in"
        protocol    = "tcp"
        port        = "80"
        source_ips = ["0.0.0.0/0", "::/0"]
    }
    rule {
        description = "Allow HTTPS in"
        direction   = "in"
        protocol    = "tcp"
        port        = "443"
        source_ips = ["0.0.0.0/0", "::/0"]
    }
    rule {
        description = "Allow custer API in"
        direction   = "in"
        protocol    = "tcp"
        port        = "6443"
        source_ips = ["0.0.0.0/0", "::/0"]
    }
    rule {
        description = "Investigate if this one is necessary"
        direction   = "in"
        protocol    = "tcp"
        port        = "9345"
        source_ips = ["0.0.0.0/0", "::/0"]
    }
}

resource "hcloud_firewall_attachment" "cluster" {
    firewall_id = hcloud_firewall.cluster.id
    server_ids  = local.node_ids
}
