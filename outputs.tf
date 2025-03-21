##
# (c) 2024 - Cloud Ops Works LLC - https://cloudops.works/
#            On GitHub: https://github.com/cloudopsworks
#            Distributed Under Apache v2.0 License
#
output "domains" {
  value = [
    for item in aws_sesv2_email_identity.domain : {
      arn               = item.arn
      domain            = item.email_identity
      type              = item.identity_type
      configuration_set = item.configuration_set_name
      dkim = {
        status                    = item.dkim_attributes[0].status
        signing_attributes_origin = item.dkim_attributes[0].signing_attributes_origin
      }
      verified_for_sending_status = item.verified_for_sending_status
    }
  ]
}

output "emails" {
  value = [
    for item in aws_sesv2_email_identity.email : {
      arn                         = item.arn
      email                       = item.email_identity
      type                        = item.identity_type
      configuration_set           = item.configuration_set_name
      verified_for_sending_status = item.verified_for_sending_status
    }
  ]
}