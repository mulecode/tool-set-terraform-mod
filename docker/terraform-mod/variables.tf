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
  }))
  default = null
}
variable "aws_iam_roles" {
  description = "AWS IAM Roles configurations"
  type = map(object({
    description                  = string
    assume_role_policy           = string
    aim_attachment_role_policies = list(string)
  }))
  default = null
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
  default = null
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
  default = null
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
  default = null
}
