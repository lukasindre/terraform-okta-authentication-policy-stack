locals {
  config = yamldecode(file(var.yaml_filepath))

  auth_frequency_map = {
    "hourly" : "PT1H",
    "daily" : "PT24H"
  }

  platform_map = {
    "ios" : {
      "os_type" : "IOS",
      "type" : "MOBILE"
    },
    "macos" : {
      "os_type" : "MACOS",
      "type" : "DESKTOP"
    },
    "chromeos" : {
      "os_type" : "CHROMEOS",
      "type" : "DESKTOP"
    },
    "android" : {
      "os_type" : "ANDROID",
      "type" : "MOBILE"
    },
    "windows" : {
      "os_type" : "WINDOWS",
      "type" : "DESKTOP"
    }
  }

  network_zones = flatten([
    for rule in local.config.rules : [
      for zone in lookup(rule, "network_zones", []) : zone
    ]
  ])
  network_zone_map = {
    for zone in data.okta_network_zone.zones : zone.name => zone.id
  }

  groups = flatten([
    for rule in local.config.rules : [
      for group in concat(lookup(rule, "group_targets", []), lookup(rule, "group_exclusions", [])) : group
    ]
  ])
  group_map = {
    for group in data.okta_group.groups : group.name => group.id
  }
}

data "okta_network_zone" "zones" {
  for_each = toset(local.network_zones)
  name     = each.value
}

data "okta_group" "groups" {
  for_each = toset(local.groups)
  name     = each.value
}

resource "okta_app_signon_policy" "this" {
  name        = local.config.name
  description = local.config.description
}

resource "okta_app_signon_policy_rule" "rules" {
  for_each                    = { for idx, rule in local.config.rules : idx => rule }
  policy_id                   = okta_app_signon_policy.this.id
  name                        = each.value.name
  access                      = each.value.access
  network_connection          = lookup(each.value, "network_zones", null) != null ? "ZONE" : null
  network_includes            = lookup(each.value, "network_zones", null) != null ? [for zone in each.value.network_zones : local.network_zone_map[zone]] : null
  priority                    = each.key
  factor_mode                 = "2FA"
  re_authentication_frequency = lookup(each.value, "step_up_auth", null) != null ? "PT0S" : lookup(each.value, "auth_frequency", null) != null ? local.auth_frequency_map[each.value.auth_frequency] : null
  groups_included             = lookup(each.value, "group_targets", null) != null ? [for group in each.value.group_targets : local.group_map[group]] : null
  groups_excluded             = lookup(each.value, "group_exclusions", null) != null ? [for group in each.value.group_exclusions : local.group_map[group]] : null
  device_is_registered        = lookup(each.value, "managed_device", null) != null ? true : null
  device_is_managed           = lookup(each.value, "managed_device", null) != null ? true : null
  dynamic "platform_include" {
    for_each = contains(lookup(each.value, "managed_device", []), "all") ? [] : lookup(each.value, "managed_device", [])
    content {
      os_type = local.platform_map[platform_include.value]["os_type"]
      type    = local.platform_map[platform_include.value]["type"]
    }
  }
  dynamic "platform_include" {
    for_each = contains(lookup(each.value, "unmanaged_device", []), "all") ? [] : lookup(each.value, "unmanaged_device", [])
    content {
      os_type = local.platform_map[platform_include.value]["os_type"]
      type    = local.platform_map[platform_include.value]["type"]
    }
  }
  constraints = lookup(each.value, "phishing_resistant", true) ? [
    jsonencode(
      {
        possession = {
          required          = true
          phishingResistant = "REQUIRED"
          userPresence      = "REQUIRED"
        }
      }
    )
  ] : null
}

resource "okta_app_signon_policy_rule" "implicit_deny" {
  name      = "Implicit Deny"
  policy_id = okta_app_signon_policy.this.id
  access    = "DENY"
  priority  = 98 # 98 is the second lowest priority to the default rule provisioned by Okta.
}
