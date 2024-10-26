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
variable "artefact_path" {
  description = "Path to the function's deployment package within the local filesystem"
  type        = string
}
variable "runtime" {
  #  https://docs.aws.amazon.com/lambda/latest/dg/API_CreateFunction.html#SSS-CreateFunction-request-Runtime
  description = "Identifier of the function's runtime"
  type        = string
  default     = "python3.9"
}
variable "handler" {
  description = "Function entrypoint class/method in your code"
  type        = string
}
variable "timeout_seconds" {
  description = "Amount of time your Lambda Function has to run in seconds"
  type        = number
  default     = 60
}
variable "memory_size" {
  description = "Amount of memory in MB your Lambda Function can use at runtime"
  type        = number
  default     = 254
}
variable "concurrent_executions" {
  description = "0 disables lambda from being triggered and -1 removes any concurrency limitations"
  type        = number
  default     = -1
}
variable "publish" {
  description = "Whether to publish creation/change as new Lambda Function Version"
  type        = bool
  default     = false
}
variable "layers" {
  description = "List of Lambda Layer Version ARNs (maximum of 5) to attach to your Lambda Function"
  type        = list(string)
  default     = []
}
variable "environment_variables" {
  description = "Lambda environment variables"
  type        = map(string)
  default     = {}
}
variable "tracing_mode" {
  description = "For Xray tracing"
  type        = string
  default     = "Active"
}
variable "role_arn" {
  description = "IAM Role ARN for the Lambda Function"
  type        = string
}
variable "permissions" {
  description = "Adds lambda permissions"
  type = list(object({
    statement_id = string
    principal    = string
    source_arn   = string
  }))
  default = []
}
variable "tags" {
  description = "Map of tags to assign to the object."
  type        = map(string)
  default     = {}
}
