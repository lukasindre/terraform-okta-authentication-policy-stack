# Basic Example
# This is a basic example of this module.
#
# We create a network zone and a group to use in the module.
#
# The module itself creates the following:
# - An authentication Policy
# - An implicit deny policy rule at priority 98
# - An access allow policy for the following criteria
#   - Traffic originating from the United States via Network Zone
#   - User authentication a part of `Example Group One`
#   - User is using an iOS device of any state (does not have to be managed, registered, etc.)

resource "okta_network_zone" "example_us_zone" {
  type = "DYNAMIC"
  dynamic_locations = [
    "US"
  ]
  name = "US Zone One"
}

resource "okta_group" "example_group_one" {
  name = "Example Group One"
}

module "example_one_module" {
  source      = "../../"
  name        = "Example Policy One"
  description = "This is an example policy."
  rules = [
    {
      name              = "Example Rule"
      access            = "ALLOW"
      network_zones     = [okta_network_zone.example_us_zone.id]
      group_targets     = [okta_group.example_group_one.id]
      unmanaged_devices = ["ios"]
    }
  ]
}