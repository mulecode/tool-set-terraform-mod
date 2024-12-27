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

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.9.7 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.74.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.74.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_aws_aim_policy"></a> [aws\_aim\_policy](#module\_aws\_aim\_policy) | ./modules/iam-policy | n/a |
| <a name="module_aws_aim_role"></a> [aws\_aim\_role](#module\_aws\_aim\_role) | ./modules/iam-role | n/a |
| <a name="module_aws_api_gateway_rest"></a> [aws\_api\_gateway\_rest](#module\_aws\_api\_gateway\_rest) | ./modules/api-gateway-rest | n/a |
| <a name="module_aws_dynamodb_table"></a> [aws\_dynamodb\_table](#module\_aws\_dynamodb\_table) | ./modules/dynamo-db | n/a |
| <a name="module_bucket"></a> [bucket](#module\_bucket) | ./modules/bucket | n/a |
| <a name="module_bucket_policy"></a> [bucket\_policy](#module\_bucket\_policy) | ./modules/bucket-policy | n/a |
| <a name="module_cloudfront"></a> [cloudfront](#module\_cloudfront) | ./modules/cloudfront | n/a |
| <a name="module_cognito"></a> [cognito](#module\_cognito) | ./modules/cognito | n/a |
| <a name="module_lambda"></a> [lambda](#module\_lambda) | ./modules/lambda-function | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_s3_object.upload_files2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_object) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account_id"></a> [account\_id](#input\_account\_id) | AWS account ID | `string` | n/a | yes |
| <a name="input_aws_api_gateways"></a> [aws\_api\_gateways](#input\_aws\_api\_gateways) | AWS API Gateways configurations | <pre>map(object({<br/>    description                  = string<br/>    disable_execute_api_endpoint = optional(bool, false)<br/>    api_body                     = string<br/>    api_body_params              = optional(map(string), {})<br/>    custom_domain                = optional(any)<br/>    quotas = optional(map(object({<br/>      enable_api_key       = bool<br/>      quota_limit          = optional(number, 500)<br/>      quota_offset         = optional(number, 2)<br/>      quota_period         = optional(string, "WEEK")<br/>      throttle_burst_limit = optional(number, 10)<br/>      throttle_rate_limit  = optional(number, 20)<br/>    })), null)<br/>  }))</pre> | `{}` | no |
| <a name="input_aws_cloudfront_distributions"></a> [aws\_cloudfront\_distributions](#input\_aws\_cloudfront\_distributions) | AWS CloudFront distributions configurations | <pre>map(object({<br/>    description         = string<br/>    default_root_object = optional(string, "index.html")<br/>    origins = optional(map(object({<br/>      connection_attempts             = optional(number)<br/>      connection_timeout              = optional(number)<br/>      domain_name                     = string<br/>      origin_path                     = optional(string)<br/>      origin_access_control_id_as_oai = optional(bool, false)<br/>      origin_access_control_id_as_oac = optional(bool, false)<br/>      s3_origin_config                = optional(bool, false)<br/>      custom_origin_config = optional(object({<br/>        http_port                = optional(number, 80)<br/>        https_port               = optional(number, 443)<br/>        origin_keepalive_timeout = optional(number, 5)<br/>        origin_protocol_policy   = optional(string, "http-only")<br/>        origin_read_timeout      = optional(number, 30)<br/>        origin_ssl_protocols = optional(list(string), [<br/>          "SSLv3",<br/>          "TLSv1",<br/>          "TLSv1.1",<br/>          "TLSv1.2",<br/>        ])<br/>      }))<br/>    })), {})<br/>    viewer_certificate = optional(object({<br/>      cloudfront_default_certificate = optional(bool, true)<br/>      acm_certificate_arn            = optional(string, null)<br/>      ssl_support_method             = optional(string, "sni-only")<br/>      minimum_protocol_version       = optional(string, "TLSv1.2_2019")<br/>    }), null)<br/>    default_cache_behavior = object({<br/>      allowed_methods = optional(list(string), [<br/>        "DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"<br/>      ])<br/>      cached_methods = optional(list(string), [<br/>        "HEAD", "GET"<br/>      ])<br/>      target_origin_id       = string<br/>      viewer_protocol_policy = optional(string, "redirect-to-https")<br/>      min_ttl                = optional(number, 0)     # 0 seconds<br/>      default_ttl            = optional(number, 3600)  # 1 hour<br/>      max_ttl                = optional(number, 86400) # 24 hours<br/>      forward_cookies        = optional(string, "none")<br/>      forward_query_string   = optional(bool, false)<br/>    })<br/>    origin_access_controls = optional(map(object({<br/>      description                       = string<br/>      signing_behavior                  = optional(string, "always")<br/>      signing_protocol                  = optional(string, "sigv4")<br/>      origin_access_control_origin_type = optional(string, "s3")<br/>    })), {})<br/>    custom_error_responses = optional(map(object({<br/>      error_code            = number<br/>      response_page_path    = string<br/>      response_code         = number<br/>      error_caching_min_ttl = string<br/>    })), {})<br/>    ordered_cache_behaviors = optional(map(object({<br/>      path_pattern           = optional(string, "/api/*")<br/>      allowed_methods        = optional(list(string), ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"])<br/>      cached_methods         = optional(list(string), ["HEAD", "GET"])<br/>      viewer_protocol_policy = optional(string, "redirect-to-https")<br/>      cache_policy_id        = optional(string, null)<br/>      min_ttl                = optional(number, 0)<br/>      default_ttl            = optional(number, 3600)<br/>      max_ttl                = optional(number, 86400)<br/>      forwarded_values = optional(object({<br/>        query_string = optional(bool, false)<br/>        headers      = optional(list(string), null)<br/>        cookies = optional(object({<br/>          forward = optional(string, "none")<br/>        }), null)<br/>      }), null)<br/>    })), {})<br/>    tags = optional(map(string), {})<br/>  }))</pre> | `{}` | no |
| <a name="input_aws_cognito_configs"></a> [aws\_cognito\_configs](#input\_aws\_cognito\_configs) | AWS Cognito configurations | <pre>map(object({<br/>    description = string<br/>    admin_create_user_config = optional(object({<br/>      allow_admin_create_user_only = bool<br/>    }), null)<br/>    custom_ui = optional(object({<br/>      css  = string<br/>      logo = string<br/>    }), null)<br/>    callback_urls                        = optional(list(string), [])<br/>    generate_client_secret               = optional(bool, false)<br/>    allowed_oauth_flows_user_pool_client = optional(bool, false)<br/>    allowed_oauth_flows                  = optional(list(string), [])<br/>    allowed_oauth_scopes                 = optional(list(string), [])<br/>    cognito_domain = optional(object({<br/>      domain = string<br/>    }), null)<br/>    custom_domain = optional(object({<br/>      domain          = string<br/>      zone_id         = string<br/>      certificate_arn = string<br/>    }), null)<br/>    resource_server = optional(object({<br/>      identifier = string<br/>      name       = string<br/>      scopes = list(object({<br/>        description = string<br/>        scope_name  = string<br/>      }))<br/>    }), null)<br/>    schemas = optional(map(object({<br/>      attribute_data_type      = string<br/>      developer_only_attribute = optional(bool, false)<br/>      mutable                  = optional(bool, false)<br/>      required                 = optional(bool, false)<br/>      string_attribute_constraints = optional(object({<br/>        max_length = optional(number, 0)<br/>        min_length = optional(number, 0)<br/>      }), null)<br/>    })), {})<br/>    tags = optional(map(string), {})<br/>  }))</pre> | `{}` | no |
| <a name="input_aws_dynamodb_tables"></a> [aws\_dynamodb\_tables](#input\_aws\_dynamodb\_tables) | AWS DynamoDB tables configurations | <pre>map(object({<br/>    billing_mode     = string<br/>    hash_key         = string<br/>    range_key        = string<br/>    read_capacity    = optional(number, null)<br/>    write_capacity   = optional(number, null)<br/>    stream_enabled   = optional(bool, false)<br/>    stream_view_type = optional(string, null)<br/>    tags             = optional(map(string), {})<br/>    attribute = list(object({<br/>      name = string<br/>      type = string<br/>    }))<br/>    global_secondary_index = optional(set(object({<br/>      hash_key           = string<br/>      name               = string<br/>      non_key_attributes = optional(list(string), null)<br/>      projection_type    = string<br/>      range_key          = optional(string, null)<br/>      read_capacity      = optional(number, null)<br/>      write_capacity     = optional(number, null)<br/>    })), [])<br/>    local_secondary_index = optional(set(object({<br/>      name               = string<br/>      non_key_attributes = list(string)<br/>      projection_type    = string<br/>      range_key          = string<br/>    })), [])<br/>    timeouts = optional(set(object({<br/>      create = string<br/>      delete = string<br/>      update = string<br/>    })), [])<br/>    ttl = optional(set(object({<br/>      attribute_name = string<br/>      enabled        = bool<br/>    })), [])<br/>  }))</pre> | `{}` | no |
| <a name="input_aws_iam_policies"></a> [aws\_iam\_policies](#input\_aws\_iam\_policies) | AWS IAM policies configurations | <pre>map(object({<br/>    description = string<br/>    policy      = string<br/>    policy_vars = optional(map(string), {})<br/>  }))</pre> | `{}` | no |
| <a name="input_aws_iam_roles"></a> [aws\_iam\_roles](#input\_aws\_iam\_roles) | AWS IAM Roles configurations | <pre>map(object({<br/>    description                  = string<br/>    assume_role_policy           = string<br/>    aim_attachment_role_policies = list(string)<br/>  }))</pre> | `{}` | no |
| <a name="input_aws_lambda_functions"></a> [aws\_lambda\_functions](#input\_aws\_lambda\_functions) | AWS Lambda functions configurations | <pre>map(object({<br/>    description           = string<br/>    handler               = string<br/>    runtime               = optional(string, "python3.9")<br/>    artefact_path         = string<br/>    role_arn              = string<br/>    environment_variables = optional(map(string), {})<br/>    permissions           = optional(list(any), [])<br/>    layers                = optional(list(string), [])<br/>  }))</pre> | `{}` | no |
| <a name="input_aws_s3_bucket_policies"></a> [aws\_s3\_bucket\_policies](#input\_aws\_s3\_bucket\_policies) | AWS S3 bucket policy configurations | <pre>map(object({<br/>    policy      = string<br/>    policy_vars = optional(map(string), {})<br/>  }))</pre> | `{}` | no |
| <a name="input_aws_s3_buckets"></a> [aws\_s3\_buckets](#input\_aws\_s3\_buckets) | AWS S3 bucket configurations | <pre>map(object({<br/>    acl        = optional(string, "private")<br/>    versioning = optional(string, "Disabled")<br/>    tags       = optional(map(string), {})<br/>  }))</pre> | `{}` | no |
| <a name="input_aws_s3_buckets_put_files"></a> [aws\_s3\_buckets\_put\_files](#input\_aws\_s3\_buckets\_put\_files) | AWS S3 bucket put files configurations | <pre>map(object({<br/>    folder_path = string<br/>    tags        = optional(map(string), {})<br/>  }))</pre> | `{}` | no |
| <a name="input_project_prefix"></a> [project\_prefix](#input\_project\_prefix) | Project prefix - prefix for all resources | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | AWS Region value | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
