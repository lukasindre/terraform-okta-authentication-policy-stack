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