This module creates an Okta authentication policy, an implicit deny policy rule attached to the policy, and user configured policy rules.

The priority of the rules is managed by the order in which you define them.
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13 |
| <a name="requirement_okta"></a> [okta](#requirement\_okta) | 4.12.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_okta"></a> [okta](#provider\_okta) | 4.12.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [okta_app_signon_policy.this](https://registry.terraform.io/providers/okta/okta/4.12.0/docs/resources/app_signon_policy) | resource |
| [okta_app_signon_policy_rule.implicit_deny](https://registry.terraform.io/providers/okta/okta/4.12.0/docs/resources/app_signon_policy_rule) | resource |
| [okta_app_signon_policy_rule.rules](https://registry.terraform.io/providers/okta/okta/4.12.0/docs/resources/app_signon_policy_rule) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_description"></a> [description](#input\_description) | Description of the policy. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name of the policy. | `string` | n/a | yes |
| <a name="input_rules"></a> [rules](#input\_rules) | List of configured rules | <pre>list(object({<br>    name               = string<br>    access             = string<br>    network_zones      = optional(list(string), [])<br>    step_up_auth       = optional(bool, false)<br>    auth_frequency     = optional(string)<br>    group_targets      = optional(list(string), [])<br>    group_exclusions   = optional(list(string), [])<br>    managed_device     = optional(list(string), [])<br>    unmanaged_device   = optional(list(string), [])<br>    phishing_resistant = optional(bool, true)<br>  }))</pre> | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_authentication_policy_id"></a> [authentication\_policy\_id](#output\_authentication\_policy\_id) | The ID of the authentication policy. |
| <a name="output_authentication_policy_rules"></a> [authentication\_policy\_rules](#output\_authentication\_policy\_rules) | The IDs of the authentication policy rules. |
| <a name="output_network_zones"></a> [network\_zones](#output\_network\_zones) | The network zones associated with the authentication policy. |
