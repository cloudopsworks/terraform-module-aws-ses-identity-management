##
# (c) 2021-2025
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
#

resource "aws_sesv2_dedicated_ip_pool" "pool" {
  for_each     = var.dedicated_ip_pools
  pool_name    = try(each.value.name, "") != "" ? each.value.name : format("%s-%s", each.value.prefix, local.system_name)
  scaling_mode = try(each.value.scaling_mode, null)
  tags         = local.all_tags
}

resource "aws_sesv2_dedicated_ip_assignment" "ip_assignment" {
  for_each = merge([
    for key, pool in var.dedicated_ip_pools : {
      for ip in try(pool.dedicated_ips, []) : "${key}-${ip}" => {
        pool_key = key
        ip       = ip
      }
    }
  ]...)
  destination_pool_name = aws_sesv2_dedicated_ip_pool.pool[each.value.pool_key].pool_name
  ip                    = each.value.ip
}