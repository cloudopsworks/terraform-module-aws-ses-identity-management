##
# (c) 2021-2025
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
#

## SES Identity configuration
# This variable is used to configure SES identities - below YAML format is expected
# identities:
#   <identity name>:
#     domain: "example.com"
#     email: "mail@example.com"
#     dkim: true | false # (default: true)
#     verify: true | false # (default: false)
#     configuration_set: "<configuration set name>" # Optional
#     dkim_private_key: "< provided private key >" # Optional
#     dkim_selector: "< provided selector >" # Optional
#     dkim_easy: true | false # (default: true)
#     dkim_easy_key_length: "RSA_1024_BIT" | "RSA_2048_BIT" (default: "RSA_1024_BIT")
#     forwarding_enabled: true | false # Optional, only for email identities
#     mail_from_domain: "<mail from domain>" # Optional, only for email identities
#     behavior_on_mx_failure: "USE_DEFAULT_VALUE" | "REJECT_MESSAGE" (default: "USE_DEFAULT_VALUE")
variable "identities" {
  description = "SES Identity configuration"
  type        = any
  default     = {}
  nullable    = false
}

## SES Dedicated IP Pool configuration
# This variable is used to configure SES dedicated IP pools - below YAML format is expected
# dedicated_ip_pools:
#   <pool name>:
#     name: "<pool name>" # Optional, used to create a pool with a specific name, required if prefix is not provided
#     prefix: "<pool prefix>" # Optional, used to create a pool with a specific prefix, required if name is not provided
#     scaling_mode: "STANDARD" | "MANAGED" # Optional, (default: "STANDARD")
#     dedicated_ips: # Optional, list of dedicated IPs to add to the pool
#       - "<ip address 1>"  # Bring Your Own IPs
#       - "<ip address 2>"  # Bring Your Own IPs
#       - "0.0.0.0"   # In order to have SES assign an IP automatically to the pool
variable "dedicated_ip_pools" {
  description = "Dedicated IP pools configuration for SES"
  type        = any
  default     = {}
  nullable    = false
}