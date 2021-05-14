
# ==========================================================
# providers
# ==========================================================

provider "digitalocean" {
  token             = var.do_token
  spaces_access_id  = var.do_spaces_id
  spaces_secret_key = var.do_spaces_key
}

# ==========================================================
# backend config and space (bucket)
# ==========================================================

terraform {
  backend "s3" {
    key                         = "terraform.tfstate"
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    # unused just to skip validation
    region = "eu-west-1"
    bucket="do-terraform-backend"
  }
}

resource "digitalocean_spaces_bucket" "do_infra_terraform_backend" {
  name   = "do-terraform-backend"
  region = "fra1"
}


# ==========================================================
# domain base configs
# ==========================================================

resource "digitalocean_domain" "domains" {
  count = length(var.domains)
  name  = var.domains[count.index]
}

resource "digitalocean_ssh_key" "ssh_keys" {
  count      = length(var.do_ssh_pub_keys)
  name       = var.do_ssh_pub_keys[count.index].name
  public_key = var.do_ssh_pub_keys[count.index].value
}

# !!!!
# provision pub key NEEDS to always be removed after use
module "provision_key" {
  do_token = var.do_token
  source   = "./modules/provision-key"
}

module "google_mx_records" {
  source   = "./modules/google-mx-records"
  domains  = [var.domains[0]]
  do_token = var.do_token
}

# ==========================================================
# loopback for rpi cluster
# ==========================================================

module "rpi_loopback" {
  source                = "./modules/loopback"
  provision_private_key = module.provision_key.private_key
  provision_public_key  = module.provision_key.public_key
  ssh_key_ids           = concat(digitalocean_ssh_key.ssh_keys[*].id, [module.provision_key.do_key_id])
  do_token              = var.do_token
  domain                = var.loopback_domain
  ipv6_target           = var.loopback_ipv6_target
  user                  = var.loopback_user
  group                 = var.loopback_group
}
