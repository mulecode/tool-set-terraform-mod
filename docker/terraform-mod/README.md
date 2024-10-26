## Terraform 1.7.4 docker image

This repository houses a Docker image equipped with Terraform, designed to be versatile across different pipeline
solutions.
This image adheres to the [3musketeers](https://3musketeersdev.netlify.app) pattern, ensuring compatibility and
promoting a standardized approach to tool usage.

## How to use this image

Given a docker compose file in the root of your project

docker-compose.yml

```yaml
services:
  terraform:
    image: ghcr.io/mulecode/tool-set-terraform-mod:latest
    working_dir: /opt/app
    volumes:
      - .:/opt/app
    environment:
      - ENV
      - AWS_REGION
      - AWS_ACCESS_KEY_ID
      - AWS_SECRET_ACCESS_KEY
      - AWS_SESSION_TOKEN
```

Makefile

```makefile
COMPOSE_RUN_TERRAFORM = docker compose run --no-deps --rm terraform

.PHONY: version
version:
	$(COMPOSE_RUN_TERRAFORM) version

.PHONY: test
test: prepare
	$(COMPOSE_RUN_TERRAFORM) test

.PHONY: lint
lint:
	$(COMPOSE_RUN_TERRAFORM) lint

.PHONY: deploy
deploy: prepare
	$(COMPOSE_RUN_TERRAFORM) deploy

.PHONY: destroy
destroy:
	$(COMPOSE_RUN_TERRAFORM) destroy
```
