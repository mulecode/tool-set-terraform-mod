variable "region" {
  description = "AWS Region value"
  type        = string
}
variable "account_id" {
  description = "AWS account ID"
  type        = string
}
variable "project_prefix" {
  description = "Project prefix"
  type        = string
}
variable "aws_iam_policies" {
  description = "IAM policies"
  type = map(object({
    description = string
    policy      = string
  }))
  default = null
}
variable "aws_iam_roles" {
  description = "IAM Roles"
  type = map(object({
    description                  = string
    assume_role_policy           = string
    aim_attachment_role_policies = list(string)
  }))
  default = null
}
variable "aws_lambda_functions" {
  description = "Lambda functions"
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
  description = "Lambda functions"
  type = map(object({
    description                  = string
    disable_execute_api_endpoint = optional(bool, false)
    api_body                     = string
    api_body_params              = optional(map(string), {})
    custom_domain                = optional(any)
    quota = optional(object({
      product_code         = string
      enable_api_key       = bool
      quota_limit          = optional(number, 500)
      quota_offset         = optional(number, 2)
      quota_period         = optional(string, "WEEK")
      throttle_burst_limit = optional(number, 10)
      throttle_rate_limit  = optional(number, 20)
    }), null)
  }))
  default = null
}
