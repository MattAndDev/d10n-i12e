provider "digitalocean" {
  token = var.do_token
}

resource "tls_private_key" "provision_keypair" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "digitalocean_ssh_key" "do_provision_key" {
  name       = "do_provision_key"
  public_key = tls_private_key.provision_keypair.public_key_openssh
}
