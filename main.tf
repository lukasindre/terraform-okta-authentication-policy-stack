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
  network_includes            = lookup(each.value, "network_zones", null)
  priority                    = each.key
  factor_mode                 = "2FA"
  re_authentication_frequency = lookup(each.value, "step_up_auth", null) != null ? "PT0S" : lookup(each.value, "auth_frequency", null) != null ? local.auth_frequency_map[each.value.auth_frequency] : null
  groups_included             = lookup(each.value, "group_targets", null)
  groups_excluded             = lookup(each.value, "group_exclusions", null)
  device_is_registered        = lookup(each.value, "managed_device", null) != null ? true : null
  device_is_managed           = lookup(each.value, "managed_device", null) != null ? true : null
  dynamic "platform_include" {
    for_each = contains(lookup(each.value, "managed_device", []), "all") ? [] : lookup(each.value, "managed_device", [])
    content {
      os_type = local.platform_map[platform_include.value]["os_type"]
      type    = local.platform_map[platform_include.value]["type"]
    }
  }
}

resource "okta_app_signon_policy_rule" "implicit_deny" {
  name      = "Implicit Deny"
  policy_id = okta_app_signon_policy.this.id
  access    = "DENY"
  priority  = 98 # 98 is the second lowest priority to the default rule provisioned by Okta.
}