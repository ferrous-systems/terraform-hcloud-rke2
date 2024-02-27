resource "hcloud_network" "clustername" {
    name     = var.clustername
    ip_range = var.network
}

resource "hcloud_network_subnet" "clustername" {
    network_id   = hcloud_network.clustername.id
    type         = "cloud"
    network_zone = var.networkzone
    ip_range     = var.subnetwork
}

resource "hcloud_load_balancer" "clustername_controlplane" {
    name               = "clustername_controlplane"
    load_balancer_type = var.lb_type
    network_zone       = var.networkzone
}

resource "hcloud_load_balancer_network" "clustername" {
    load_balancer_id = hcloud_load_balancer.clustername_controlplane.id
    network_id       = hcloud_network.clustername.id
    ip               = var.internalbalancerip
}

resource "hcloud_load_balancer_service" "clustername_joiner" {
    load_balancer_id = hcloud_load_balancer.clustername_controlplane.id
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

resource "hcloud_load_balancer_service" "clustername_kublet" {
    load_balancer_id = hcloud_load_balancer.clustername_controlplane.id
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

resource "hcloud_load_balancer_target" "clustername_controlplane" {
    type             = "label_selector"
    load_balancer_id = hcloud_load_balancer.clustername_controlplane.id
    label_selector   = "cluster=${var.clustername},master=true"
    use_private_ip   = true
    depends_on       = [hcloud_load_balancer_network.clustername]
}

resource "hcloud_ssh_key" "root" {
    name       = "root"
    public_key = file("~/.ssh/id_rsa.pub")
}

resource "hcloud_server" "master" {
    count       = var.master_count
    name        = "${var.clustername}-master-${count.index}"
    location    = var.location
    image       = "ubuntu-22.04"
    server_type = var.master_type
    labels      = {
        cluster : var.clustername,
        master : "true"
    }
    backups   = true
    ssh_keys  = [hcloud_ssh_key.root.name]
    user_data = templatefile("${path.module}/server_userdata.tmpl", {
        extra_ssh_keys      = var.extra_ssh_keys,
        rke2_cluster_secret = var.rke2_cluster_secret,
        lb_address          = hcloud_load_balancer_network.clustername.ip,
        lb_external_v4      = hcloud_load_balancer.clustername_controlplane.ipv4,
        lb_external_v6      = hcloud_load_balancer.clustername_controlplane.ipv6,
        master_index        = count.index,
        rke2_version        = var.rke2_version,
        domains             = var.domains,
        clustername         = var.clustername,
        lb_id               = hcloud_load_balancer_network.clustername.id,
        api_token           = var.hcloud_token
    })
}

resource "hcloud_server_network" "master" {
    count      = var.master_count
    server_id  = hcloud_server.master[count.index].id
    network_id = hcloud_network.clustername.id
}

resource "hcloud_server" "agent" {
    count       = var.agent_count
    name        = "${var.clustername}-agent-${count.index}"
    location    = var.location
    image       = "ubuntu-22.04"
    server_type = var.agent_type
    labels      = {
        cluster : var.clustername,
        agent : "true"
    }
    backups   = true
    ssh_keys  = [hcloud_ssh_key.root.name]
    user_data = templatefile("${path.module}/agent_userdata.tmpl", {
        extra_ssh_keys      = var.extra_ssh_keys,
        rke2_cluster_secret = var.rke2_cluster_secret,
        lb_address          = hcloud_load_balancer_network.clustername.ip,
        agent_index         = count.index,
        rke2_version        = var.rke2_version
        clustername         = var.clustername,
        lb_id               = hcloud_load_balancer_network.clustername.id,
        api_token           = var.hcloud_token
    })
}

resource "hcloud_server_network" "agent" {
    count      = var.agent_count
    server_id  = hcloud_server.agent[count.index].id
    network_id = hcloud_network.clustername.id
}
