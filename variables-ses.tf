##
# (c) 2024 - Cloud Ops Works LLC - https://cloudops.works/
#            On GitHub: https://github.com/cloudopsworks
#            Distributed Under Apache v2.0 License
#

## SES Identity configuration
# This variable is used to configure SES identities - below YAML format is expected
# identities:
#   domain: "example.com"
#   email: "mail@example.com"
#   dkim: true | false # (default: true)
#   verification: true | false # (default: false)
#   configuration_set: "<configuration set name>" # Optional
#   dkim_private_key: "< provided private key >" # Optional
#   dkim_selector: "< provided selector >" # Optional
#   dkim_easy: true | false # (default: true)
#   dkim_easy_key_length: "RSA_1024_BIT" | "RSA_2048_BIT" (default: "RSA_1024_BIT")
variable "identities" {
  description = "SES Identity configuration"
  type        = any
  default     = {}
}