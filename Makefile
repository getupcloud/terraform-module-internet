test: init
	terraform validate

init:
	terraform init

fmt:
	terraform fmt -recursive

