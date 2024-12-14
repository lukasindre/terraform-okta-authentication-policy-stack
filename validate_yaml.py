import click
import yaml
from pydantic_core import ValidationError

from schema import Root


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
