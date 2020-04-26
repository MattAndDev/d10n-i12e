variable "do_token" {}

variable "domains" {
  type = list(string)
}

variable "records" {
  type = list(object({
    name     = string
    value    = string
    priority = string
  }))
  default = [
    {
      name     = "@"
      value    = "aspmx.l.google.com."
      priority = 1
    },
    {
      name     = "@"
      value    = "alt1.aspmx.l.google.com."
      priority = 5
    },
    {
      name     = "@"
      value    = "alt2.aspmx.l.google.com."
      priority = 5
    },
    {
      name     = "@"
      value    = "aspmx2.googlemail.com."
      priority = 10
    },
    {
      name     = "@"
      value    = "aspmx3.googlemail.com."
      priority = 10
    },
  ]
}