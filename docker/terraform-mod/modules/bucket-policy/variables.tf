variable "bucket_id" {
  description = "Bucket id"
  type        = string
}
variable "policy" {
  description = "The policy document. This is a JSON formatted string."
  type        = string
  default     = ""
}
variable "policy_vars" {
  description = "Variables to be used in the policy document"
  type        = optional(map(string), {})
  default     = {}
}
