This module creates an Okta authentication policy, an implicit deny policy rule attached to the policy, and user configured policy rules.

The priority of the rules is managed by the order in which you define them.

The module expects a yaml file with the following structure:
## Root
| name          | type                | required   | default   | description               |
|---------------|---------------------|------------|-----------|---------------------------|
| `name`        | `<class 'str'>`     | `True`     |           | Name of the policy        |
| `description` | `<class 'str'>`     | `True`     |           | Description of the policy |
| `rules`       | `list[schema.Rule]` | `True`     |           | List of configured rules  |
## Rule
| name               | type                                                                                             | required   | default   | description                                                                            |
|--------------------|--------------------------------------------------------------------------------------------------|------------|-----------|----------------------------------------------------------------------------------------|
| `name`             | `<class 'str'>`                                                                                  | `True`     |           | Name of the rule                                                                       |
| `access`           | `typing.Literal['ALLOW', 'DENY']`                                                                | `True`     |           | Access type.                                                                           |
| `network_zones`    | `typing.Optional[list[str]]`                                                                     | `False`    |           | List of network zone IDs.                                                              |
| `step_up_auth`     | `typing.Optional[bool]`                                                                          | `False`    |           | Whether or not MFA is required each auth.                                              |
| `auth_frequency`   | `typing.Optional[typing.Literal['daily', 'hourly']]`                                             | `False`    |           | Frequency of auth.                                                                     |
| `group_targets`    | `typing.Optional[list[str]]`                                                                     | `False`    |           | Groups to target for the policy rule.                                                  |
| `group_exclusions` | `typing.Optional[list[str]]`                                                                     | `False`    |           | Groups to exclude for the policy rule.                                                 |
| `managed_device`   | `typing.Optional[list[typing.Literal['all', 'ios', 'macos', 'android', 'windows', 'chromeos']]]` | `False`    |           | Managed devices to target for the policy rule.  Cannot be set with `unmanaged_device`. |
| `unmanaged_device` | `typing.Optional[list[typing.Literal['all', 'ios', 'macos', 'android', 'windows', 'chromeos']]]` | `False`    |           | Unmanaged devices to target for the policy rule.  Cannot be set with `managed_device`. |
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
| <a name="input_yaml_filepath"></a> [yaml\_filepath](#input\_yaml\_filepath) | Path to the yaml file. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_authentication_policy_id"></a> [authentication\_policy\_id](#output\_authentication\_policy\_id) | The ID of the authentication policy. |
