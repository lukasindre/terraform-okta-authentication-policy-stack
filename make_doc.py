import subprocess


def main():
    doc = """This module creates an Okta authentication policy, an implicit deny policy rule attached to the policy, and user configured policy rules.

The priority of the rules is managed by the order in which you define them.\n"""
    tf_doc = subprocess.run(
        ["terraform-docs", "markdown", "."], capture_output=True
    ).stdout.decode("utf-8")
    doc += tf_doc
    with open("README.md", "w") as f:
        f.write(doc)


if __name__ == "__main__":
    main()
