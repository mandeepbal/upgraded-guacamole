.DEFAULT_GOAL:=help
SHELL:=/bin/bash
projName=lamps

##@ Build Commands

.PHONY: build tf-fmt

build:  ## Build Docker Image
	docker build -t ${projName}:${tag} .

tf-fmt:  ## Format Terraform Files
	cd terraform; \
	terraform fmt

##@ Terraform Commands

.PHONY: plan apply destroy

plan:  ## Terraform Plan
	cd terraform; \
	terraform init; \
	terraform plan

apply:  ## Terraform Apply
	cd terraform; \
	terraform init; \
	terraform apply

destroy:  ## Terraform Destroy
	cd terraform; \
	terraform init; \
	terraform destroy

##@ Helpers

.PHONY: help

help:  ## Help command
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)
