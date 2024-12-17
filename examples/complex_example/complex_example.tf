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
