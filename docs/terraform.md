## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 6.4 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 6.8.0 |
| <a name="provider_aws.cross_account"></a> [aws.cross\_account](#provider\_aws.cross\_account) | 6.8.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_tags"></a> [tags](#module\_tags) | cloudopsworks/tags/local | 1.0.9 |

## Resources

| Name | Type |
|------|------|
| [aws_route53_record.amazonses_dkim](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.cross_amazonses_dkim](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_sesv2_dedicated_ip_assignment.ip_assignment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sesv2_dedicated_ip_assignment) | resource |
| [aws_sesv2_dedicated_ip_pool.pool](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sesv2_dedicated_ip_pool) | resource |
| [aws_sesv2_email_identity.domain](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sesv2_email_identity) | resource |
| [aws_sesv2_email_identity.email](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sesv2_email_identity) | resource |
| [aws_sesv2_email_identity_feedback_attributes.email](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sesv2_email_identity_feedback_attributes) | resource |
| [aws_sesv2_email_identity_mail_from_attributes.email](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/sesv2_email_identity_mail_from_attributes) | resource |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_route53_zone.cross_domain](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |
| [aws_route53_zone.domain](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/route53_zone) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_cross_account"></a> [cross\_account](#input\_cross\_account) | (optional) Cross account support for SES identity validation | `bool` | `false` | no |
| <a name="input_dedicated_ip_pools"></a> [dedicated\_ip\_pools](#input\_dedicated\_ip\_pools) | Dedicated IP pools configuration for SES | `any` | `{}` | no |
| <a name="input_extra_tags"></a> [extra\_tags](#input\_extra\_tags) | Extra tags to add to the resources | `map(string)` | `{}` | no |
| <a name="input_identities"></a> [identities](#input\_identities) | SES Identity configuration | `any` | `{}` | no |
| <a name="input_is_hub"></a> [is\_hub](#input\_is\_hub) | Is this a hub or spoke configuration? | `bool` | `false` | no |
| <a name="input_org"></a> [org](#input\_org) | Organization details | <pre>object({<br/>    organization_name = string<br/>    organization_unit = string<br/>    environment_type  = string<br/>    environment_name  = string<br/>  })</pre> | n/a | yes |
| <a name="input_spoke_def"></a> [spoke\_def](#input\_spoke\_def) | Spoke ID Number, must be a 3 digit number | `string` | `"001"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_domains"></a> [domains](#output\_domains) | # (c) 2021-2025 Cloud Ops Works LLC - https://cloudops.works/ Find us on: GitHub: https://github.com/cloudopsworks WebSite: https://cloudops.works Distributed Under Apache v2.0 License |
| <a name="output_emails"></a> [emails](#output\_emails) | n/a |
