##
# (c) 2024 - Cloud Ops Works LLC - https://cloudops.works/
#            On GitHub: https://github.com/cloudopsworks
#            Distributed Under Apache v2.0 License
#

locals {
  domains = {
    for key, item in var.identities : key => item
    if try(item.domain, "") != ""
  }
  emails = {
    for key, item in var.identities : key => item
    if try(item.email, "") != ""
  }

  dkim = merge([
    for key, domain in local.domains : {
      for item in range(length(aws_sesv2_email_identity.domain[key].dkim_signing_attributes[0].tokens)) :
      "${key}-${item}" => {
        zone_id = data.aws_route53_zone.domain[key].zone_id
        domain  = domain.domain
        token   = aws_sesv2_email_identity.domain[key].dkim_signing_attributes.tokens[item]
      }
    } if try(domain.dkim, true) == true && try(domain.verify, false) == true
  ]...)
}

resource "aws_sesv2_email_identity" "domain" {
  for_each               = local.domains
  email_identity         = each.value.domain
  configuration_set_name = try(each.value.configuration_set, null)
  dynamic "dkim_signing_attributes" {
    for_each = try(each.value.dkim, true) == true ? [each.value] : []
    content {
      domain_signing_private_key = try(each.value.dkim_private_key, null)
      domain_signing_selector    = try(each.value.dkim_selector, null)
      next_signing_key_length    = try(each.value.dkim_easy, true) == true ? try(each.value.dkim_easy_key_length, "RSA_1024_BIT") : null
    }
  }
  tags = local.all_tags
}

resource "aws_sesv2_email_identity" "email" {
  for_each               = local.emails
  email_identity         = each.value.email
  configuration_set_name = try(each.value.configuration_set, null)
  tags                   = local.all_tags
}

data "aws_route53_zone" "domain" {
  for_each = {
    for key, domain in local.domains : key => domain
    if try(domain.verify, false) == true
  }
  name = each.value.domain
}

# resource "aws_route53_record" "amazonses" {
#   for_each = {
#     for key, domain in local.domains : key => domain
#     if try(domain.verify, false) == true
#   }
#   zone_id = data.aws_route53_record.this[each.key].zone_id
#   name    = "_amazonses.${each.value.domain}"
#   type    = "TXT"
#   ttl     = 300
#   records = [aws_ses_domain_identity.this[each.key].verification_token]
# }

resource "aws_route53_record" "amazonses_dkim" {
  for_each        = local.dkim
  zone_id         = each.value.zone_id
  allow_overwrite = true
  name            = "${each.value.token}._domainkey"
  type            = "CNAME"
  ttl             = "600"
  records         = ["${each.value.token}.dkim.amazonses.com"]
}
