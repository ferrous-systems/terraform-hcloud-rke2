resource "hcloud_firewall" "cluster" {
    name   = var.name
    labels = {
        cluster = var.name
    }
    rule {
        direction  = "in"
        protocol   = "tcp"
        port       = "80"
        source_ips = ["0.0.0.0/0", "::/0"]
    }
    rule {
        direction  = "in"
        protocol   = "tcp"
        port       = "443"
        source_ips = ["0.0.0.0/0", "::/0"]
    }
    rule {
        direction  = "in"
        protocol   = "tcp"
        port       = "22"
        source_ips = ["0.0.0.0/0", "::/0"]
    }
    apply_to {
        label_selector = "cluster=${var.name}"
    }
}
