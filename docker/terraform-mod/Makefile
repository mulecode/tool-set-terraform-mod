$(VERBOSE).SILENT:
.DEFAULT_GOAL := help

ENV ?= default
ROOT_DIR ?= /opt/app
TERRAFORM_DIR ?= /modules/terraform

TERRAFORM_PLAN_DIR := $(ROOT_DIR)$(TERRAFORM_DIR)
TERRAFORM_CONFIG_DIR := $(ROOT_DIR)$(TERRAFORM_DIR)/config/$(ENV)

TERRAFORM_MODULE := /opt/terraform

####################################################################################
##@ Main Commands
####################################################################################

.PHONY: lint
lint: format ## Terraform format

.PHONY: test
test: init validate plan show-plan ## Initialise, plan and show-plan

.PHONY: deploy
deploy: init plan apply ## Initialise, plan and apply terraform

.PHONE: destroy
destroy: init destroy apply ## Initialise, plan, destroy and apply terraform

####################################################################################
##@ Terraform Commands
####################################################################################

.PHONY: version
version: ## Terraform version
	@terraform version

.PHONY: validate
validate: ## Terraform validate
	@TF_DATA_DIR="$(TERRAFORM_CONFIG_DIR)/.terraform" terraform -chdir=$(TERRAFORM_MODULE) validate -no-color

.PHONY: format
format: ## Terraform validate
	@TF_DATA_DIR="$(TERRAFORM_CONFIG_DIR)/.terraform" terraform -chdir=$(TERRAFORM_MODULE) fmt -check --recursive

.PHONY: init
init: ## Initialise terraform
	@TF_DATA_DIR="$(TERRAFORM_CONFIG_DIR)/.terraform" terraform -chdir=$(TERRAFORM_MODULE) init \
		-backend-config="$(TERRAFORM_CONFIG_DIR)/remote.tfvars" \
		--reconfigure -upgrade

.PHONY: plan
plan: ## Terraform plan
	@TF_DATA_DIR="$(TERRAFORM_CONFIG_DIR)/.terraform" terraform -chdir=$(TERRAFORM_MODULE) plan \
		$(foreach file,$(filter-out $(TERRAFORM_CONFIG_DIR)/remote.tfvars,$(wildcard $(TERRAFORM_CONFIG_DIR)/*.tfvars)),-var-file="$(file)") \
		--out "$(TERRAFORM_PLAN_DIR)/build.plan"

.PHONY: show-plan
show-plan: ## Show the plan
	@TF_DATA_DIR="$(TERRAFORM_CONFIG_DIR)/.terraform" terraform -chdir=$(TERRAFORM_MODULE) show \
		-json "$(TERRAFORM_PLAN_DIR)/build.plan" > "$(TERRAFORM_PLAN_DIR)/plan.json"

.PHONY: destroy
destroy: ## Terraform destroy
	@TF_DATA_DIR="$(TERRAFORM_CONFIG_DIR)/.terraform" -chdir=$(MODULE_PATH) plan --destroy \
		$(foreach file,$(filter-out $(TERRAFORM_CONFIG_DIR)/remote.tfvars,$(wildcard $(TERRAFORM_CONFIG_DIR)/*.tfvars)),-var-file="$(file)") \
		--out "$(TERRAFORM_CONFIG_DIR)/build.plan"

.PHONY: apply
apply: ## Terraform apply
	@TF_DATA_DIR="$(TERRAFORM_CONFIG_DIR)/.terraform" terraform -chdir=$(TERRAFORM_MODULE) apply "$(TERRAFORM_PLAN_DIR)/build.plan"

####################################################################################
##@ Utils
####################################################################################

.PHONY: update_readme
update_readme: ## Updates readme file with terraform modules
	@echo "Updating README.md"
	@terraform-docs markdown table --output-file ../../README.md --output-mode inject .

.PHONY: help
help: ## Display this help
	awk \
	  'BEGIN { \
	    FS = ":.*##"; printf "\nUsage:\n"\
			"  make \033[36m<target>\033[0m\n" \
	  } /^[a-zA-Z_-]+:.*?##/ { \
	    printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 \
	  } /^##@/ { \
	    printf "\n\033[1m%s\033[0m\n", substr($$0, 5) \
	  } ' $(MAKEFILE_LIST)
