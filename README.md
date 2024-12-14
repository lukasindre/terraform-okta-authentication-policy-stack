This module creates an Okta authentication policy, an implicit deny policy rule attached to the policy, and user configured policy rules.

The priority of the rules is managed by the order in which you define them.

The module expects a yaml file with the following structure:

## Root Level Spec
| key           | type            | required | default | description                   | constraints |
|---------------|-----------------|----------|---------|-------------------------------|-------------|
| `name`        | `string`        | yes      | n/a     | The name of the policy        | n/a         |
| `description` | `string`        | yes      | n/a     | The description of the policy | n/a         |
| `rules`       | `[]rule_object` | yes      | n/a     | The rules of the policy       | n/a         |

## Rule Object Spec
| key                | type       | required | default | description                                                                                                                         | constraints                                     |
|--------------------|------------|----------|---------|-------------------------------------------------------------------------------------------------------------------------------------|-------------------------------------------------|
| `name`             | `string`   | yes      | n/a     | The name of the rule                                                                                                                | n/a                                             |
| `access`           | `string`   | yes      | n/a     | The access of the rule                                                                                                              | `[ALLOW \| DENY]`                               |
| `network_zones`    | `[]string` | no       | `null`  | The network zone IDs of the rule                                                                                                    | n/a                                             |
| `step_up_auth`     | `bool`     | no       | `null`  | Whether you require step up auth for a rule. Setting this to true overrides `auth_frequency`.                                       | n/a                                             |
| `auth_frequency`   | `string`   | no       | `null`  | The frequency of authentication for a rule.  This is overridden if `step_up_auth` is set.                                           | `[daily \| hourly]`                             |
| `group_targets`    | `[]string` | no       | `null`  | The group IDs of the rule                                                                                                           | n/a                                             |
| `group_exclusions` | `[]string` | no       | `null`  | The group IDs to exclude from the rule                                                                                              | n/a                                             |
| `managed_device`   | `[]string` | no       | `null`  | Whether or not the rule requires managed device for access.  If you provide `all` in the list, all managed platforms are permitted. | `[all, ios, android, chromeos, windows, macos]` |

## Example YAML
The following yaml would configure the following
- An authentication policy named `test policy`, with a description of `test description`
- An implicit deny authentication policy rule w/ priority of 98 to ensure it is the last rule in the stack
- An authentication policy rule named `test network allow` that behaves as such:
  - Any user in group `00gasdfqwer`, but not in group `00gqwerasdf`
  - on network zone `nzasdfqwer`
  - on any managed device
  - is allowed access, requiring MFA on every sign in (step up)
```yaml
name: test policy
description: test description
rules:
  - name: test network allow
    access: ALLOW
    network_zones:
      - nzasdfqwer
    step_up_auth: true
    auth_frequency: daily
    group_targets:
      - 00gasdfqwer
    group_exclusions:
      - 00gqwerasdf
    managed_device:
      - all
      - ios
      - windows
```

## Modules

No modules.

## Resources

| Name                                                                                                                                        | Type     |
|---------------------------------------------------------------------------------------------------------------------------------------------|----------|
| [okta_app_signon_policy.this](https://registry.terraform.io/providers/okta/okta/4.12.0/docs/resources/app_signon_policy)                    | resource |
| [okta_app_signon_policy_rule.implicit_deny](https://registry.terraform.io/providers/okta/okta/4.12.0/docs/resources/app_signon_policy_rule) | resource |
| [okta_app_signon_policy_rule.rules](https://registry.terraform.io/providers/okta/okta/4.12.0/docs/resources/app_signon_policy_rule)         | resource |

## Inputs

| Name                                                                        | Description            | Type     | Default | Required |
|-----------------------------------------------------------------------------|------------------------|----------|---------|:--------:|
| <a name="input_yaml_filepath"></a> [yaml\_filepath](#input\_yaml\_filepath) | Path to the yaml file. | `string` | n/a     |   yes    |

## Outputs

| Name                                                                                                             | Description                          |
|------------------------------------------------------------------------------------------------------------------|--------------------------------------|
| <a name="output_authentication_policy_id"></a> [authentication\_policy\_id](#output\_authentication\_policy\_id) | The ID of the authentication policy. |
