variable "do_token" {}
variable "ssh_key_ids" {
  type    = list(string)
  default = []
}
variable "provision_private_key" {}
variable "provision_public_key" {}
variable "user" {}
variable "group" {}
variable "ipv6_target" {}
variable "domain" {}