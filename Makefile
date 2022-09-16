.DEFAULT_GOAL:=help
SHELL:=/bin/bash
projName=lamps
awsProfile=ktacct
awsRegion=us-east-2

##@ Build Commands

.PHONY: build push mirror-base tf-fmt tf-lock cft-validate

build:  ## Build Docker Image
	cd scripts; \
	./dckr-build.sh ${awsProfile} ${awsRegion} ${tag}

push: build ## Build and Push Docker Image
	cd scripts; \
	./dckr-push.sh ${awsProfile} ${awsRegion} ${tag}

mirror-base:  ## Build and Push Docker Image
	cd scripts; \
	./mirror-base.sh ${awsProfile} ${awsRegion}

tf-fmt:  ## Format Terraform Files
	cd terraform; \
	terraform fmt

tf-lock:  ## Format Terraform Files
	cd terraform; \
	terraform providers lock \
  -platform=linux_arm64 \
  -platform=linux_amd64 \
  -platform=darwin_amd64 \
  -platform=windows_amd64

cft-validate:  ## Validate CFT
	cd cloudformation; \
	aws cloudformation validate-template --profile ${awsProfile} --region ${awsRegion} --template-body file://lamp-prereq.yaml

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
