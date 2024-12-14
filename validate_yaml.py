import typing

import click
import yaml
from pydantic import BaseModel
from pydantic_core import ValidationError


class Rule(BaseModel):
    name: str
    access: typing.Literal["ALLOW", "DENY"]
    network_zones: typing.Optional[list[str]] = None
    step_up_auth: typing.Optional[bool] = None
    auth_frequency: typing.Optional[typing.Literal["daily", "hourly"]] = None
    group_targets: typing.Optional[list[str]] = None
    group_exclusions: typing.Optional[list[str]] = None
    managed_device: typing.Optional[
        list[typing.Literal["all", "ios", "macos", "android", "windows", "chromeos"]]
    ] = None


class Root(BaseModel):
    name: str
    description: str
    rules: list[Rule]


@click.command()
@click.argument("file", type=click.Path(exists=True))
def main(file: str):
    with open(file, "r") as f:
        data = yaml.safe_load(f)
    try:
        Root(**data)
        print(f"{file} - Valid YAML based on declared spec.")
    except ValidationError as e:
        print(f"{file} - Invalid YAML based on declared spec.")
        print(e)


if __name__ == "__main__":
    main()
