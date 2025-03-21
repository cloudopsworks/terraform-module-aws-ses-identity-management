##
# (c) 2024 - Cloud Ops Works LLC - https://cloudops.works/
#            On GitHub: https://github.com/cloudopsworks
#            Distributed Under Apache v2.0 License
#
output "domains" {
  value = aws_sesv2_email_identity.domain
  sensitive = true
}

output "emails" {
  value = aws_sesv2_email_identity.email
  sensitive = true
}