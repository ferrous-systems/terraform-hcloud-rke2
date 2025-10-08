resource "tls_private_key" "root" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "hcloud_ssh_key" "root" {
  name       = var.cluster_name
  public_key = tls_private_key.root.public_key_openssh
}

data "hcloud_ssh_keys" "additional_ssh_keys" {
  with_selector = var.additional_ssh_keys_selector
}

output "keys" {
  value = concat([hcloud_ssh_key.root.id], data.hcloud_ssh_keys.additional_ssh_keys.ssh_keys.*.name)
}