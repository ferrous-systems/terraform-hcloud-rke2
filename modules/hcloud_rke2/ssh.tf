resource "tls_private_key" "root" {
    algorithm = "RSA"
    rsa_bits  = 4096
}

resource "hcloud_ssh_key" "root" {
    name       = var.name
    public_key = tls_private_key.root.public_key_openssh
}
