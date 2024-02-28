resource "hcloud_network" "private" {
    name     = "${var.clustername}-private"
    ip_range = var.network
}

resource "hcloud_network_subnet" "cluster" {
    network_id   = hcloud_network.private.id
    type         = "cloud"
    network_zone = var.networkzone
    ip_range     = var.subnet
}

resource "hcloud_load_balancer" "cluster" {
    name               = "${var.clustername}-cluster"
    load_balancer_type = var.lb_type
    location           = var.location
}

resource "hcloud_load_balancer_network" "cluster" {
    load_balancer_id = hcloud_load_balancer.cluster.id
    subnet_id        = hcloud_network_subnet.cluster.id
    ip               = var.internalbalancerip
}

resource "hcloud_load_balancer_service" "cluster_control" {
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

resource "hcloud_load_balancer_service" "cluster_api" {
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

resource "hcloud_load_balancer_target" "cluster" {
    type             = "label_selector"
    load_balancer_id = hcloud_load_balancer.cluster.id
    label_selector   = "cluster=${var.clustername},master=true"
    use_private_ip   = true
    depends_on       = [hcloud_load_balancer_network.cluster]
}

resource "hcloud_ssh_key" "root" {
    name       = "root"
    public_key = file("~/.ssh/id_rsa.pub")
}

resource "hcloud_server" "master" {
    count       = var.master_count
    name        = "${var.clustername}-master-${count.index}"
    location    = var.location
    image       = var.image
    server_type = var.master_type
    labels      = {
        cluster : var.clustername,
        master : "true"
    }
    backups   = false
    ssh_keys  = [hcloud_ssh_key.root.name]
    user_data = templatefile("${path.module}/master_userdata.tftpl", {
        extra_ssh_keys      = var.extra_ssh_keys,
        rke2_cluster_secret = var.rke2_cluster_secret,
        lb_address          = hcloud_load_balancer_network.cluster.ip,
        lb_external_v4      = hcloud_load_balancer.cluster.ipv4,
        lb_external_v6      = hcloud_load_balancer.cluster.ipv6,
        master_index        = count.index,
        rke2_version        = var.rke2_version,
        domains             = var.domains,
        clustername         = var.clustername,
        lb_id               = hcloud_load_balancer_network.cluster.id,
        api_token           = var.hcloud_token
    })
}

resource "hcloud_server_network" "master" {
    count     = var.master_count
    server_id = hcloud_server.master[count.index].id
    subnet_id = hcloud_network_subnet.cluster.id
}

resource "hcloud_server" "agent" {
    count       = var.agent_count
    name        = "${var.clustername}-agent-${count.index}"
    location    = var.location
    image       = var.image
    server_type = var.agent_type
    labels      = {
        cluster : var.clustername,
        agent : "true"
    }
    backups   = false
    ssh_keys  = [hcloud_ssh_key.root.name]
    user_data = templatefile("${path.module}/agent_userdata.tftpl", {
        extra_ssh_keys      = var.extra_ssh_keys,
        rke2_cluster_secret = var.rke2_cluster_secret,
        lb_address          = hcloud_load_balancer_network.cluster.ip,
        agent_index         = count.index,
        rke2_version        = var.rke2_version
        clustername         = var.clustername,
        lb_id               = hcloud_load_balancer_network.cluster.id,
        api_token           = var.hcloud_token
    })
}

resource "hcloud_server_network" "agent" {
    count     = var.agent_count
    server_id = hcloud_server.agent[count.index].id
    subnet_id = hcloud_network_subnet.cluster.id
}
