variable "prefix" {
  description = "Prefix for the Role resource"
  type        = string
}
variable "name" {
  description = "Unique name for your Lambda Function"
  type        = string
  validation {
    condition     = can(regex("[a-z0-9-]+(-){1}[a-z0-9-]+", var.name))
    error_message = "Name must be lower cased dashed, Example: service-name-feature-name."
  }
}
variable "description" {
  description = "Description of what your Lambda Function does"
  type        = string
}
variable "api_body" {
  description = "Body for REST API"
  type        = string
}
variable "stage_name" {
  description = "Api Gateway stage name"
  type        = string
  default     = "api"
}
variable "disable_execute_api_endpoint" {
  description = "Disable the default REST API endpoint"
  type        = bool
  default     = false
}
variable "quota" {
  description = "Api Gateway quota settings"
  type = object({
    product_code         = string
    enable_api_key       = optional(bool, false)
    quota_limit          = optional(number, 20)
    quota_offset         = optional(number, 2)
    quota_period         = optional(string, "WEEK")
    throttle_burst_limit = optional(number, 5)
    throttle_rate_limit  = optional(number, 10)
  })
  default = null
}
variable "custom_domain" {
  description = "Adds a custom domain"
  type = object({
    domain_name         = string,
    zone_id             = string,
    acm_certificate_arn = string
    base_path_mapping   = optional(bool, false)
    security_policy     = optional(string, null)
    truststore_uri      = optional(string, null)
  })
  default = null
}
variable "logging" {
  description = "Adds cloudwatch logging"
  type = object({
    retention_in_days = optional(number, 7)
  })
  default = null
}
variable "tags" {
  description = "Map of tags to assign to the object."
  type        = map(string)
  default     = {}
}
