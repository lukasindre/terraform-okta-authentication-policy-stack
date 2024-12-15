import typing

from pydantic import BaseModel, Field, model_validator


class Rule(BaseModel):
    name: str = Field(description="Name of the rule")
    access: typing.Literal["ALLOW", "DENY"] = Field(description="Access type.")
    network_zones: typing.Optional[list[str]] = Field(
        None,
        description="List of network zone names.  These must exist.  Consider using `depends_on` in your module declaration on required network zones.",
    )
    step_up_auth: typing.Optional[bool] = Field(
        None, description="Whether or not MFA is required each auth."
    )
    auth_frequency: typing.Optional[typing.Literal["daily", "hourly"]] = Field(
        None, description="Frequency of auth."
    )
    group_targets: typing.Optional[list[str]] = Field(
        None,
        description="Group names to target for the policy rule.  These must exist.  Consider using `depends_on` in your module declaration on required groups.",
    )
    group_exclusions: typing.Optional[list[str]] = Field(
        None,
        description="Group names to exclude for the policy rule.  These must exist.  Consider using `depends_on` in your module declaration on required groups.",
    )
    managed_device: typing.Optional[
        list[typing.Literal["all", "ios", "macos", "android", "windows", "chromeos"]]
    ] = Field(
        None,
        description="Managed devices to target for the policy rule.  Cannot be set with `unmanaged_device`.",
    )
    unmanaged_device: typing.Optional[
        list[typing.Literal["all", "ios", "macos", "android", "windows", "chromeos"]]
    ] = Field(
        None,
        description="Unmanaged devices to target for the policy rule.  Cannot be set with `managed_device`.",
    )

    @model_validator(mode="after")
    def check_exclusive_management(self):
        if self.managed_device and self.unmanaged_device:
            raise ValueError(
                "`managed_device` and `unmanaged_device` cannot be defined together."
            )
        return self


class Root(BaseModel):
    name: str = Field(description="Name of the policy")
    description: str = Field(description="Description of the policy")
    rules: list[Rule] = Field(description="List of configured rules")
