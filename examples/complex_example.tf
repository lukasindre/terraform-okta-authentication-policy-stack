# Complex Example
# This complex example shows some more flexibility and options for policy configuration.
#
# A couple of groups and network zones are created for use within the module.
#
# The module itself configures the following resources:
# - An Authentication Policy
# - An implicit deny policy rule with priority of `98`
# - The following rules with priority in which they're listed:
#   - A rule to deny traffic from Canada
#   - A rule that allows access with these criteria:
#     - Traffic from the US
#     - User in the managed device group
#     - User not in the unmanaged device group
#     - User is accessing from a chromeOS, macOS, or Windows device
#     - User must authenticate daily
#   - A rule that allows access with these criteria
#     - Traffic is from the US
#     - User is in the unmanaged device group
#     - User is not in the managed device group
#     - User is accessing from an iOS or Android device
#     - User must authenticate at every sign in
#     - User must authenticate with phishing resistant credentials

resource "okta_network_zone" "example_us_zone" {
  type = "DYNAMIC"
  dynamic_locations = [
    "US"
  ]
  name = "US Zone Complex"
}

resource "okta_network_zone" "example_canada_zone" {
  type = "DYNAMIC"
  dynamic_locations = [
    "CA"
  ]
  name = "Canada Zone Complex"
}

resource "okta_group" "unmanaged_device_users" {
  name = "Unmanaged Device Users"
}

resource "okta_group" "managed_device_users" {
  name = "Managed Device Users"
}

module "complex_example" {
  source      = "../../"
  name        = "Complex Example Policy"
  description = "This is a complex example policy."
  rules = [
    {
      name          = "Deny Canada Access"
      access        = "DENY"
      network_zones = [okta_network_zone.example_canada_zone.id]
    },
    {
      name             = "Allow Access from US from Managed Device users"
      access           = "ALLOW"
      network_zones    = [okta_network_zone.example_us_zone.id]
      auth_frequency   = "daily"
      group_targets    = [okta_group.managed_device_users.id]
      group_exclusions = [okta_group.unmanaged_device_users.id]
      managed_device   = ["chromeos", "windows", "macos"]
    },
    {
      name               = "Allow access from from US from Unmanaged Device users"
      access             = "ALLOW"
      network_zones      = [okta_network_zone.example_us_zone.id]
      step_up_auth       = true
      group_targets      = [okta_group.unmanaged_device_users.id]
      group_exclusions   = [okta_group.managed_device_users.id]
      phishing_resistant = true
      unmanaged_device   = ["ios", "android"]
    }
  ]
}
