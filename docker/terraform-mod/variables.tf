variable "region" {
  description = "AWS Region value"
  type        = string
}
variable "account_id" {
  description = "AWS account ID"
  type        = string
}
variable "project_prefix" {
  description = "Project prefix - prefix for all resources"
  type        = string
}
variable "aws_iam_policies" {
  description = "AWS IAM policies configurations"
  type = map(object({
    description = string
    policy      = string
    policy_vars = optional(map(string), {})
  }))
  default = {}
}
variable "aws_iam_roles" {
  description = "AWS IAM Roles configurations"
  type = map(object({
    description                  = string
    assume_role_policy           = string
    aim_attachment_role_policies = list(string)
  }))
  default = {}
}
variable "aws_lambda_functions" {
  description = "AWS Lambda functions configurations"
  type = map(object({
    description           = string
    handler               = string
    runtime               = optional(string, "python3.9")
    artefact_path         = string
    role_arn              = string
    environment_variables = optional(map(string), {})
    permissions           = optional(list(any), [])
    layers                = optional(list(string), [])
  }))
  default = {}
}
variable "aws_api_gateways" {
  description = "AWS API Gateways configurations"
  type = map(object({
    description                  = string
    disable_execute_api_endpoint = optional(bool, false)
    api_body                     = string
    api_body_params              = optional(map(string), {})
    custom_domain                = optional(any)
    quotas = optional(map(object({
      enable_api_key       = bool
      quota_limit          = optional(number, 500)
      quota_offset         = optional(number, 2)
      quota_period         = optional(string, "WEEK")
      throttle_burst_limit = optional(number, 10)
      throttle_rate_limit  = optional(number, 20)
    })), null)
  }))
  default = {}
}
variable "aws_dynamodb_tables" {
  description = "AWS DynamoDB tables configurations"
  type = map(object({
    billing_mode     = string
    hash_key         = string
    range_key        = string
    read_capacity    = optional(number, null)
    write_capacity   = optional(number, null)
    stream_enabled   = optional(bool, false)
    stream_view_type = optional(string, null)
    tags             = optional(map(string), {})
    attribute = list(object({
      name = string
      type = string
    }))
    global_secondary_index = optional(set(object({
      hash_key           = string
      name               = string
      non_key_attributes = optional(list(string), null)
      projection_type    = string
      range_key          = optional(string, null)
      read_capacity      = optional(number, null)
      write_capacity     = optional(number, null)
    })), [])
    local_secondary_index = optional(set(object({
      name               = string
      non_key_attributes = list(string)
      projection_type    = string
      range_key          = string
    })), [])
    timeouts = optional(set(object({
      create = string
      delete = string
      update = string
    })), [])
    ttl = optional(set(object({
      attribute_name = string
      enabled        = bool
    })), [])
  }))
  default = {}
}
variable "aws_s3_buckets" {
  description = "AWS S3 bucket configurations"
  type = map(object({
    acl        = optional(string, "private")
    versioning = optional(string, "Disabled")
    tags       = optional(map(string), {})
  }))
  default = {}
}
variable "aws_s3_bucket_policies" {
  description = "AWS S3 bucket policy configurations"
  type = map(object({
    policy      = string
    policy_vars = optional(map(string), {})
  }))
  default = {}
}
variable "aws_s3_buckets_put_files" {
  description = "AWS S3 bucket put files configurations"
  type = map(object({
    folder_path = string
    tags        = optional(map(string), {})
  }))
  default = {}
}
variable "aws_cloudfront_distributions" {
  description = "AWS CloudFront distributions configurations"
  type = map(object({
    description         = string
    default_root_object = optional(string, "index.html")
    origins = optional(map(object({
      connection_attempts             = optional(number)
      connection_timeout              = optional(number)
      domain_name                     = string
      origin_path                     = optional(string)
      origin_access_control_id_as_oai = optional(bool, false)
      origin_access_control_id_as_oac = optional(bool, false)
      s3_origin_config                = optional(bool, false)
      custom_origin_config = optional(object({
        http_port                = optional(number, 80)
        https_port               = optional(number, 443)
        origin_keepalive_timeout = optional(number, 5)
        origin_protocol_policy   = optional(string, "http-only")
        origin_read_timeout      = optional(number, 30)
        origin_ssl_protocols = optional(list(string), [
          "SSLv3",
          "TLSv1",
          "TLSv1.1",
          "TLSv1.2",
        ])
      }))
    })), {})
    viewer_certificate = optional(object({
      cloudfront_default_certificate = optional(bool, true)
      acm_certificate_arn            = optional(string, null)
      ssl_support_method             = optional(string, "sni-only")
      minimum_protocol_version       = optional(string, "TLSv1.2_2019")
    }), null)
    default_cache_behavior = object({
      allowed_methods = optional(list(string), [
        "DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"
      ])
      cached_methods = optional(list(string), [
        "HEAD", "GET"
      ])
      target_origin_id       = string
      viewer_protocol_policy = optional(string, "redirect-to-https")
      min_ttl                = optional(number, 0)     # 0 seconds
      default_ttl            = optional(number, 3600)  # 1 hour
      max_ttl                = optional(number, 86400) # 24 hours
      forward_cookies        = optional(string, "none")
      forward_query_string   = optional(bool, false)
    })
    origin_access_controls = optional(map(object({
      description                       = string
      signing_behavior                  = optional(string, "always")
      signing_protocol                  = optional(string, "sigv4")
      origin_access_control_origin_type = optional(string, "s3")
    })), {})
    custom_error_responses = optional(map(object({
      error_code            = number
      response_page_path    = string
      response_code         = number
      error_caching_min_ttl = string
    })), {})
    ordered_cache_behaviors = optional(map(object({
      path_pattern           = optional(string, "/api/*")
      allowed_methods        = optional(list(string), ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"])
      cached_methods         = optional(list(string), ["HEAD", "GET"])
      viewer_protocol_policy = optional(string, "redirect-to-https")
      cache_policy_id        = optional(string, null)
      min_ttl                = optional(number, 0)
      default_ttl            = optional(number, 3600)
      max_ttl                = optional(number, 86400)
      forwarded_values = optional(object({
        query_string = optional(bool, false)
        headers      = optional(list(string), null)
        cookies = optional(object({
          forward = optional(string, "none")
        }), null)
      }), null)
    })), {})
    tags = optional(map(string), {})
  }))
  default = {}
}
variable "aws_cognito_configs" {
  description = "AWS Cognito configurations"
  type = map(object({
    description = string
    admin_create_user_config = optional(object({
      allow_admin_create_user_only = bool
    }), null)
    custom_ui = optional(object({
      css  = string
      logo = string
    }), null)
    callback_urls                        = optional(list(string), [])
    generate_client_secret               = optional(bool, false)
    allowed_oauth_flows_user_pool_client = optional(bool, false)
    allowed_oauth_flows                  = optional(list(string), [])
    allowed_oauth_scopes                 = optional(list(string), [])
    cognito_domain = optional(object({
      domain = string
    }), null)
    custom_domain = optional(object({
      domain          = string
      zone_id         = string
      certificate_arn = string
    }), null)
    resource_server = optional(object({
      identifier = string
      name       = string
      scopes = list(object({
        description = string
        scope_name  = string
      }))
    }), null)
    tags = optional(map(string), {})
  }))
  default = {}
}
