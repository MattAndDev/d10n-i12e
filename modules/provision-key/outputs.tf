output "public_key" {
  value = tls_private_key.provision_keypair.public_key_openssh
}
output "private_key" {
  value     = tls_private_key.provision_keypair.private_key_pem
  sensitive = true
}
output "do_key_id" {
  value     = digitalocean_ssh_key.do_provision_key.id
  sensitive = true
}
