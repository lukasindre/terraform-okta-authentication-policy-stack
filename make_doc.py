import subprocess

from pydantic_core._pydantic_core import PydanticUndefined
from tabulate import tabulate

from schema import Root, Rule


def main():
    doc = """This module creates an Okta authentication policy, an implicit deny policy rule attached to the policy, and user configured policy rules.

The priority of the rules is managed by the order in which you define them.

The module expects a yaml file with the following structure:\n"""
    models = [Root, Rule]
    for model in models:
        doc += generate_table(model) + "\n"
    tf_doc = subprocess.run(
        ["terraform-docs", "markdown", "."], capture_output=True
    ).stdout.decode("utf-8")
    doc += tf_doc
    with open("README.md", "w") as f:
        f.write(doc)


def generate_table(model) -> str:
    field_info = [
        {
            "name": wrap_backtick(name),
            "type": wrap_backtick(field.annotation),
            "required": wrap_backtick(field.is_required()),
            "default": wrap_backtick(field.default)
            if field.default is not PydanticUndefined
            else None,
            "description": field.description,
        }
        for name, field in model.model_fields.items()
    ]
    table_string = f"## {model.__name__}\n"
    return table_string + tabulate(field_info, headers="keys", tablefmt="github")


def wrap_backtick(value: str) -> str:
    return f"`{value}`"


if __name__ == "__main__":
    main()
