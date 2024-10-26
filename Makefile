$(VERBOSE).SILENT:
.DEFAULT_GOAL := help

# The variable IMAGE will be used to name the docker image
DOCKER_REPO := ghcr.io/mulecode/tool-set-

####################################################################################
##@ Main Commands
####################################################################################

.PHONY: docker_login
docker_login: ## Login to docker registry
	echo $(GITHUB_TOKEN) | docker login ghcr.io -u mulecode --password-stdin

.PHONY: docker_build
docker_build: TAG = test
docker_build: ## Build docker image
	cd ./docker/$(IMAGE) && \
	docker build -t $(DOCKER_REPO)$(IMAGE):$(TAG) .

.PHONY: docker_push
docker_push: ## Push docker image
	docker push $(DOCKER_REPO)$(IMAGE):$(TAG)

.PHONY: docker_pull
docker_pull: ## Pull docker image
	docker pull $(DOCKER_REPO)$(IMAGE):$(TAG)

.PHONY: docker_tag
docker_tag: ## Push a new tag for the latest image
	docker tag $(DOCKER_REPO)$(IMAGE):$(TAG) $(DOCKER_REPO)$(IMAGE):$(NEW_TAG)

####################################################################################
##@ Testing and Validation
####################################################################################

.PHONY: docker_lint
docker_lint: ## Link Dockerfile
	cd ./docker/$(IMAGE) && \
	docker run --rm -i ghcr.io/hadolint/hadolint:latest < Dockerfile

.PHONY: docker_vulnerability_scan
docker_vulnerability_scan: TAG = test
docker_vulnerability_scan: ## Scan docker image for vulnerabilities
	docker build -t $(DOCKER_REPO)$(IMAGE):$(TAG) ./docker/$(IMAGE) && \
	snyk container test $(DOCKER_REPO)$(IMAGE):$(TAG) --file=./docker/$(IMAGE)/Dockerfile --policy-path=./docker/$(IMAGE)/.snyk

.PHONY: docker_scout
docker_scout: TAG = test
docker_scout: ## Docker Scout image for vulnerabilities
	docker build -t $(DOCKER_REPO)$(IMAGE):$(TAG) ./docker/$(IMAGE) && \
	docker scout quickview $(DOCKER_REPO)$(IMAGE):$(TAG) && \
	docker scout recommendations $(DOCKER_REPO)$(IMAGE):$(TAG)

####################################################################################
##@ Utils
####################################################################################
.PHONY: help
help: ## Display this help
	@awk \
	  'BEGIN { \
	    FS = ":.*##"; printf "\nUsage:\n"\
			"  make \033[36m<target>\033[0m\n" \
	  } /^[a-zA-Z_-]+:.*?##/ { \
	    printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 \
	  } /^##@/ { \
	    printf "\n\033[1m%s\033[0m\n", substr($$0, 5) \
	  } ' $(MAKEFILE_LIST)

