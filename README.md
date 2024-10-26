# tool-set-terraform-mod

This repository houses Docker images equipped with tool-set-terraform-mod, designed to be versatile across
different pipeline solutions.
These images adhere to the [3musketeers](https://3musketeers.pages.dev) pattern, ensuring compatibility and
promoting a standardized approach to tool usage.

## Why use docker for pipelines?

Using Docker in pipelines streamlines software development and deployment by encapsulating applications and dependencies
in containers, ensuring consistent environments throughout the development lifecycle. This eliminates the "it works on
my machine" problem and fosters collaboration across teams.

Docker's lightweight design enables efficient resource utilization, facilitating scalable applications. The isolation in
containers minimizes tool conflicts in the pipeline, enhancing stability. Moreover, Docker's compatibility with popular
CI/CD platforms simplifies integration, offering faster deployment, simplified dependency management, and improved
collaboration.

Overall, Docker enables organizations to create secure, standardized environments, accelerating time-to-market for
software products and features.

## Benefits of adhering to the 3musketeers pattern

1. **Consistency Across Environments:**
   The pattern encourages a consistent approach to defining and running commands, promoting uniformity across
   development, testing, and production environments. This consistency helps mitigate issues related to
   environment-specific discrepancies.
2. **Simplified Dependency Management:**
   By encapsulating tool commands within Docker containers, the organization can manage dependencies more effectively.
   This simplification reduces the likelihood of conflicts and ensures that each tool operates in an isolated,
   well-defined environment.
3. **Reproducibility in Workflows:**
   The pattern facilitates reproducibility in workflows by encapsulating tool configurations and dependencies. This
   ensures that the same set of tools and versions are utilized throughout the development lifecycle, enhancing
   predictability in software development.
4. **Ease of Collaboration:**
   Adopting the 3musketeers pattern promotes ease of collaboration among development teams. The standardized approach to
   tooling and containerization makes it straightforward for team members to share and collaborate on projects without
   the complexities associated with varied development setups.
5. **Scalability and Flexibility:**
   The pattern's containerized approach enhances scalability and flexibility in handling different tools and their
   versions. This adaptability is particularly valuable in dynamic development environments, allowing teams to scale
   projects efficiently.
6. **Enhanced Security:**
   By encapsulating tools within Docker containers, security can be improved. Containers provide isolation, reducing the
   risk of conflicts between tools and enhancing the overall security posture of the development and deployment process.
7. **Efficient CI/CD Integration:**
   The pattern aligns well with continuous integration and continuous deployment (CI/CD) practices. Docker containers
   with encapsulated tools can be seamlessly integrated into CI/CD pipelines, ensuring a smooth and reliable automation
   process.
8. **Standardized Development Practices:**
   Standardizing on the 3musketeers pattern establishes a common set of practices within the organization. This shared
   approach helps in onboarding new team members more efficiently and reduces the learning curve associated with diverse
   development setups.

## How to use this image

In the root of your project create a docker-compose.yml file with the following content:

```yaml
services:
  terraform:
    image: ghcr.io/mulecode/tool-set-terraform-mod:1.7.0
    working_dir: /opt/app
    volumes:
      - .:/opt/app
    environment:
      - ENV
      - ROOT_DIR=/opt/app
      - TERRAFORM_DIR=/modules/terraform
      - AWS_REGION
      - AWS_ACCESS_KEY_ID
      - AWS_SECRET_ACCESS_KEY
      - AWS_SESSION_TOKEN
```

by the given environment variables above, you must have your terraform configuration in the following structure:

```
/modules
   /terraform
      /config
         /${ENV}
            remote.tfvars
            main.tfvars
            ...
```
and a makefile with the following content:

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


Check for more patterns at [3musketeers](https://3musketeers.pages.dev)
