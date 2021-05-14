
# Configure the DigitalOcean Provider
provider "digitalocean" {
  token = var.do_token
}

# local records
locals {
  records = [
    {
      type  = "A"
      name  = "@"
      value = digitalocean_droplet.loopback.ipv4_address
      ttl   = 30
    },
    {
      type  = "A"
      name  = "*"
      value = digitalocean_droplet.loopback.ipv4_address
      ttl   = 30
    },
    {
      type  = "AAAA"
      name  = "@"
      value = digitalocean_droplet.loopback.ipv6_address
      ttl   = 30
    },
    {
      type  = "AAAA"
      name  = "*"
      value = digitalocean_droplet.loopback.ipv6_address
      ttl   = 30
    }
  ]
}

resource "local_file" "loopback_id_rsa_local" {
  content         = var.provision_private_key
  filename        = "${path.module}/ansible/id_rsa"
  file_permission = "0700"
}

resource "digitalocean_droplet" "loopback" {
  ipv6       = true
  image      = "ubuntu-18-04-x64"
  name       = "loopback"
  region     = "fra1"
  size       = "s-1vcpu-1gb"
  ssh_keys   = var.ssh_key_ids
  depends_on = [local_file.loopback_id_rsa_local]
  provisioner "local-exec" {
    # horrible, but indent somehow breaks ansible
    command = <<EOT
sleep 30 &&
export ANSIBLE_HOST_KEY_CHECKING=False &&
ansible-playbook \
-i '${self.ipv4_address},' \
-e "\
ansible_user=root \
ansible_ssh_private_key_file="${path.module}/ansible/id_rsa" \
user=${var.user} \
ipv6_target=${var.ipv6_target}
group=${var.group} \
provision_pub_key='${chomp(var.provision_public_key)}' \
" ./modules/loopback/ansible/playbook.yml
    EOT
  }
  provisioner "local-exec" {
    command = "rm ${path.module}/ansible/id_rsa"
  }
}

resource "digitalocean_record" "loopback_records" {
  count = length(local.records)
  domain = var.domain
  type = local.records[count.index].type
  name = local.records[count.index].name
  value = local.records[count.index].value
  ttl = local.records[count.index].ttl
}


