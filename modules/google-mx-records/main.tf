provider "digitalocean" {
  token = var.do_token
}

locals {
  mx_records = flatten([
    for entry in var.domains : [
      for record in var.records : {
        domain_name = entry
        value       = record.value
        name        = record.name
        priority    = record.priority
      }
    ]
  ])
}


resource "digitalocean_record" "gogle_mx_records" {
  count    = length(local.mx_records)
  type     = "MX"
  domain   = local.mx_records[count.index].domain_name
  name     = local.mx_records[count.index].name
  value    = local.mx_records[count.index].value
  priority = local.mx_records[count.index].priority
}
