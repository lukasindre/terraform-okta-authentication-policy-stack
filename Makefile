fix:
	terraform fmt -recursive
	poetry run ruff check . --select I --fix
	poetry run ruff format .
	poetry run ruff check . --fix

check:
	terraform fmt -recursive -check
	terraform validate
	tflint
	poetry run ruff check .
	poetry run ruff format --check .

test-plan:
	terraform plan -var-file=test.tfvars

test-apply:
	terraform apply -var-file=test.tfvars -autoapprove

docs:
	poetry run python make_doc.py
