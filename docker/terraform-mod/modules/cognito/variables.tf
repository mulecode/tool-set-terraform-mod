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
variable "admin_create_user_config" {
  description = "Configuration for AdminCreateUser"
  type = object({
    allow_admin_create_user_only = bool
  })
  default = null
}
variable "custom_ui" {
  description = "Configuration for custom UI"
  type = object({
    css  = string
    logo = string
  })
  default = null
}
variable "callback_urls" {
  description = "List of allowed callback URLs for the identity providers"
  type        = list(string)
  default     = []
}
variable "generate_client_secret" {
  description = "Generate client secret"
  type        = bool
  default     = false
}
variable "allowed_oauth_flows_user_pool_client" {
  description = "List of allowed OAuth flows for the user pool client"
  type        = bool
  default     = false
}
variable "allowed_oauth_flows" {
  description = "List of allowed OAuth flows"
  type        = list(string)
  default     = []
}
variable "allowed_oauth_scopes" {
  description = "List of allowed OAuth scopes"
  type        = list(string)
  default     = []
}
variable "cognito_domain" {
  description = "Enable cognito domain name"
  type = object({
    domain = string
  })
  default = null
}
variable "custom_domain" {
  description = "Enable cognito custom domain name"
  type = object({
    domain          = string
    zone_id         = string
    certificate_arn = string
  })
  default = null
}
variable "resource_server" {
  description = "Enable cognito resource server"
  type = object({
    identifier = string
    name       = string
    scopes = list(object({
      description = string
      scope_name  = string
    }))
  })
  default = null
}
variable "schemas" {
  description = "List of schemas for the user pool"
  type = map(object({
    attribute_data_type      = string
    developer_only_attribute = bool
    mutable                  = bool
    required                 = bool
    string_attribute_constraints = object({
      max_length = number
      min_length = number
    })
  }))
  default = null
}
variable "tags" {
  description = "Map of tags to assign to the object."
  type        = map(string)
  default     = {}
}
