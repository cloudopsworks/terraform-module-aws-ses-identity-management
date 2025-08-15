##
# (c) 2021-2025
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
#

data "aws_route53_zone" "cross_domain" {
  provider = aws.cross_account
  for_each = {
    for key, domain in local.domains : key => domain
    if try(domain.verify, false) == true && var.cross_account
  }
  name         = try(each.value.validation_domain, each.value.domain)
  private_zone = false
}

resource "aws_route53_record" "cross_amazonses_dkim" {
  provider = aws.cross_account
  for_each = {
    for k, v in local.dkim : k => v if !var.cross_account
  }
  zone_id         = data.aws_route53_zone.cross_domain[each.value.domain_key].id
  allow_overwrite = true
  name            = "${each.value.token}._domainkey"
  type            = "CNAME"
  ttl             = "600"
  records         = ["${each.value.token}.dkim.amazonses.com"]
}