#resource "hcloud_firewall" "cluster" {
#    name   = var.cluster_name
#    labels = {
#        cluster = var.cluster_name
#    }
#    rule {
#        direction  = "in"
#        protocol   = "tcp"
#        port       = "22"
#        source_ips = ["0.0.0.0/0", "::/0"]
#    }
#    apply_to {
#        label_selector = "cluster=${var.cluster_name}"
#    }
#}
