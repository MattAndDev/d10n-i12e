variable "do_token" {}
variable "do_spaces_id" {}
variable "do_spaces_key" {}

variable "do_ssh_pub_keys" {
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}

# domains
variable "domains" {
  type = list(string)
}

# loopback variables
variable "loopback_domain" {}
variable "loopback_user" {}
variable "loopback_group" {}
variable "loopback_ipv6_target" {}