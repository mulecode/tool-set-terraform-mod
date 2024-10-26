variable "account_id" {
  description = "AWS account ID"
  type        = string
}
variable "prefix" {
  description = "Prefix for the Role resource"
  type        = string
}
variable "name" {
  description = "Name for the Role resource"
  type        = string
}

variable "description" {
  description = "Description for the Role resource"
  type        = string
}

variable "assume_role_policy" {
  description = "Assume policy document in JSON format for the assume role policy"
  type        = string
}

variable "aim_role_policies" {
  description = "IAM policy document in JSON format for the role"
  type = map(object({
    policy = string
  }))
  default = {}
}

variable "aim_attachment_role_policies" {
  description = "IAM policy ARN for attaching to the role"
  type        = list(string)
  default     = []
}

variable "tags" {
  default     = {}
  description = "Map of key/value metadata"
  type        = map(string)
}
