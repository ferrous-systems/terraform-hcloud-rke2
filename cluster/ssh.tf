resource "tls_private_key" "root" {
    algorithm = "RSA"
    rsa_bits  = 4096
}

resource "hcloud_ssh_key" "root" {
    name       = var.cluster_name
    public_key = tls_private_key.root.public_key_openssh
}

resource "local_file" "ssh_key" {
    content         = tls_private_key.root.private_key_openssh
    filename        = "id_rsa_${var.cluster_name}"
    file_permission = "0600"
}
