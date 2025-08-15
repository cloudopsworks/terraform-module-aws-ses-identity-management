##
# (c) 2021-2025
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
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
      for item in range(try(domain.dkim_selector, null) != null ? 1 : 3) :
      "${key}-${item}" => {
        domain_key = key
        domain     = domain.domain
        token      = aws_sesv2_email_identity.domain[key].dkim_signing_attributes[0].tokens[item]
      }
    } if try(domain.dkim, true) == true && try(domain.verify, false) == true
  ]...)
}

resource "aws_sesv2_email_identity" "domain" {
  for_each               = local.domains
  email_identity         = each.value.domain
  configuration_set_name = try(each.value.configuration_set, null)
  dynamic "dkim_signing_attributes" {
    for_each = try(each.value.dkim, true) == true ? [1] : []
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

resource "aws_sesv2_email_identity_feedback_attributes" "email" {
  for_each = {
    for key, email in local.emails : key => email
    if try(email.forwarding_enabled, null) != null
  }
  email_identity           = each.value.email
  email_forwarding_enabled = each.value.forwarding_enabled
}

resource "aws_sesv2_email_identity_mail_from_attributes" "email" {
  for_each = {
    for key, email in local.emails : key => email
    if try(email.mail_from_domain, null) != null || try(email.behavior_on_mx_failure, null) != null
  }
  email_identity         = aws_sesv2_email_identity.email[each.key].email_identity
  mail_from_domain       = try(each.value.mail_from_domain, null)
  behavior_on_mx_failure = try(each.value.behavior_on_mx_failure, null)
}

data "aws_route53_zone" "domain" {
  for_each = {
    for key, domain in local.domains : key => domain
    if try(domain.verify, false) == true && !var.cross_account
  }
  name         = try(each.value.validation_domain, each.value.domain)
  private_zone = false
}

resource "aws_route53_record" "amazonses_dkim" {
  for_each = {
    for k, v in local.dkim : k => v if !var.cross_account
  }
  zone_id         = data.aws_route53_zone.domain[each.value.domain_key].id
  allow_overwrite = true
  name            = "${each.value.token}._domainkey"
  type            = "CNAME"
  ttl             = "600"
  records         = ["${each.value.token}.dkim.amazonses.com"]
}
