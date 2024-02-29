resource "hcloud_network" "cluster" {
    name     = var.cluster_name
    ip_range = var.network
}

resource "hcloud_network_subnet" "nodes" {
    network_id   = hcloud_network.cluster.id
    type         = "cloud"
    network_zone = var.network_zone
    ip_range     = var.subnet
}

resource "hcloud_load_balancer" "cluster" {
    name               = "${var.cluster_name}-cluster"
    load_balancer_type = var.lb_type
    location           = var.location
    labels             = {
        cluster = var.cluster_name
    }
}

resource "hcloud_load_balancer_network" "cluster" {
    load_balancer_id = hcloud_load_balancer.cluster.id
    subnet_id        = hcloud_network_subnet.nodes.id
    ip               = var.lb_ip
}

resource "hcloud_load_balancer_service" "supervisor" {
    load_balancer_id = hcloud_load_balancer.cluster.id
    protocol         = "tcp"
    listen_port      = 9345
    destination_port = 9345
    health_check {
        protocol = "tcp"
        port     = 9345
        interval = 5
        timeout  = 2
        retries  = 5
    }
}

resource "hcloud_load_balancer_service" "k8s_api" {
    load_balancer_id = hcloud_load_balancer.cluster.id
    protocol         = "tcp"
    listen_port      = 6443
    destination_port = 6443
    health_check {
        protocol = "tcp"
        port     = 6443
        interval = 5
        timeout  = 2
        retries  = 2
    }
}

resource "hcloud_load_balancer_service" "http" {
    load_balancer_id = hcloud_load_balancer.cluster.id
    protocol         = "tcp"
    listen_port      = 80
    destination_port = 80
    health_check {
        protocol = "tcp"
        port     = 80
        interval = 5
        timeout  = 2
        retries  = 2
    }
}

resource "hcloud_load_balancer_service" "https" {
    load_balancer_id = hcloud_load_balancer.cluster.id
    protocol         = "tcp"
    listen_port      = 443
    destination_port = 443
    health_check {
        protocol = "tcp"
        port     = 443
        interval = 5
        timeout  = 2
        retries  = 2
    }
}

resource "hcloud_load_balancer_target" "cluster" {
    type             = "label_selector"
    load_balancer_id = hcloud_load_balancer.cluster.id
    label_selector   = "cluster=${var.cluster_name},master=true"
    use_private_ip   = true
    depends_on       = [hcloud_load_balancer_network.cluster]
}

data "hcloud_load_balancers" "cluster" {
    with_selector = "cluster=${var.cluster_name}"
}

resource "random_string" "token" {
    length = 32
}

locals {
    lb_deployed      = length(data.hcloud_load_balancers.cluster.load_balancers) > 0
    fqdn             = "api.${var.cluster_name}.${var.domain}"
    master_user_data = [
        for index in range(var.master_count) :
        templatefile("${path.module}/master_setup.sh.tpl", {
            rke2_version  = var.rke2_version
            cluster_token = random_string.token.id
            initial       = index == 0 && !local.lb_deployed
            fqdn          = local.fqdn
            lb_ip         = hcloud_load_balancer_network.cluster.ip
            lb_ext_v4     = hcloud_load_balancer.cluster.ipv4
            lb_ext_v6     = hcloud_load_balancer.cluster.ipv6
        })
    ]
    agent_user_data = [
        for index in range(var.agent_count) :
        templatefile("${path.module}/agent_setup.sh.tpl", {
            rke2_version  = var.rke2_version
            cluster_token = random_string.token.id
            lb_ip         = hcloud_load_balancer_network.cluster.ip
        })
    ]
}

resource "random_string" "master_suffix" {
    count   = var.master_count
    length  = 6
    upper   = false
    special = false
    keepers = {
        location    = var.location
        server_type = var.master_type
        image       = var.image
        user_data   = local.master_user_data[count.index]
    }
}

resource "hcloud_ssh_key" "root" {
    name       = "root"
    public_key = file("~/.ssh/id_rsa.pub")
}

resource "hcloud_server" "master" {
    count       = var.master_count
    name        = "${var.cluster_name}-master-${random_string.master_suffix[count.index].id}"
    location    = var.location
    server_type = var.master_type
    image       = var.image
    backups     = false
    ssh_keys    = [hcloud_ssh_key.root.id]
    user_data   = local.master_user_data[count.index]
    labels      = {
        cluster = var.cluster_name
        master  = "true"
    }
    lifecycle {
        create_before_destroy = true
        ignore_changes        = [ssh_keys]
    }
}

resource "hcloud_server_network" "master" {
    count     = var.master_count
    server_id = hcloud_server.master[count.index].id
    subnet_id = hcloud_network_subnet.nodes.id
    lifecycle {
        create_before_destroy = true
    }
}

resource "random_string" "agent_suffix" {
    count   = var.agent_count
    length  = 6
    upper   = false
    special = false
    keepers = {
        location    = var.location
        server_type = var.agent_type
        image       = var.image
        user_data   = local.agent_user_data[count.index]
    }
}

resource "hcloud_server" "agent" {
    count       = var.agent_count
    name        = "${var.cluster_name}-agent-${random_string.agent_suffix[count.index].id}"
    location    = var.location
    server_type = var.agent_type
    image       = var.image
    backups     = false
    ssh_keys    = [hcloud_ssh_key.root.id]
    user_data   = local.agent_user_data[count.index]
    labels      = {
        cluster = var.cluster_name
        agent   = "true"
    }
    lifecycle {
        create_before_destroy = true
        ignore_changes        = [ssh_keys]
    }
    depends_on = [hcloud_server_network.master]
}

resource "hcloud_server_network" "agent" {
    count     = var.agent_count
    server_id = hcloud_server.agent[count.index].id
    subnet_id = hcloud_network_subnet.nodes.id
    lifecycle {
        create_before_destroy = true
    }
}

#data "remote_file" "kubeconfig" {
#    path = "/etc/rancher/rke2/rke2.yaml"
#    conn {
#        host  = hcloud_server.master[0].ipv4_address
#        user  = "root"
#        agent = true
#    }
#}
