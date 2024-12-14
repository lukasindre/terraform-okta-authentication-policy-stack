fix:
	terraform fmt -recursive

check:
	terraform fmt -recursive -check
	terraform validate
	tflint

test-plan:
	terraform plan -var-file=test.tfvars

test-apply:
	terraform apply -var-file=test.tfvars -autoapprove

docs:
	terraform-docs markdown . >> README.md
