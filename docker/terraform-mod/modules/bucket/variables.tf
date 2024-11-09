variable "prefix" {
  description = "Prefix for the Role resource"
  type        = string
}
variable "name" {
  description = "Unique name for your cloudfront distribution"
  type        = string
  validation {
    condition     = can(regex("[a-z0-9-]+(-){1}[a-z0-9-]+", var.name))
    error_message = "Name must be lower cased dashed, Example: service-name-feature-name."
  }
}
variable "acl" {
  description = "The canned ACL to apply. Defaults to private."
  type        = string
}
variable "versioning" {
  description = "Enables or Disables bucket versioning"
  type        = string
  default     = "Disabled"
  validation {
    condition     = contains(["Enabled", "Disabled"], var.versioning)
    error_message = "Valid values for var: versioning are (Enabled, Disabled)."
  }
}
variable "tags" {
  description = "Map of tags to assign to the object."
  type        = map(string)
  default     = {}
}
