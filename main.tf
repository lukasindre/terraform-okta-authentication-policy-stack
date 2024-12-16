locals {
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
  network_zones = flatten(tolist(toset([
    for rule in var.rules : rule.network_zones
  ])))
}

resource "okta_app_signon_policy" "this" {
  name        = var.name
  description = var.description
}

resource "okta_app_signon_policy_rule" "rules" {
  for_each                    = { for idx, rule in var.rules : idx => rule }
  policy_id                   = okta_app_signon_policy.this.id
  name                        = each.value.name
  access                      = each.value.access
  network_connection          = length(each.value.network_zones) > 0 ? "ZONE" : null
  network_includes            = length(each.value.network_zones) > 0 ? tolist(toset(each.value.network_zones)) : null
  priority                    = each.key
  factor_mode                 = "2FA"
  re_authentication_frequency = each.value.step_up_auth ? "PT0S" : each.value.auth_frequency != null ? local.auth_frequency_map[each.value.auth_frequency] : null
  groups_included             = length(each.value.group_targets) > 0 ? each.value.group_targets : null
  groups_excluded             = length(each.value.group_exclusions) > 0 ? each.value.group_exclusions : null
  device_is_registered        = length(each.value.managed_device) > 0 ? true : null
  device_is_managed           = length(each.value.managed_device) > 0 ? true : null
  dynamic "platform_include" {
    for_each = contains(each.value.managed_device, "all") ? [] : each.value.managed_device
    content {
      os_type = local.platform_map[platform_include.value]["os_type"]
      type    = local.platform_map[platform_include.value]["type"]
    }
  }
  dynamic "platform_include" {
    for_each = contains(each.value.unmanaged_device, "all") ? [] : each.value.unmanaged_device
    content {
      os_type = local.platform_map[platform_include.value]["os_type"]
      type    = local.platform_map[platform_include.value]["type"]
    }
  }
  constraints = each.value.phishing_resistant ? [
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
