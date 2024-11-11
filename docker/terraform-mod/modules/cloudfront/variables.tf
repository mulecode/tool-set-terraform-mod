variable "prefix" {
  description = "Prefix for the Role resource"
  type        = string
}
variable "name" {
  description = "Unique name for your cloudfront distribution"
  type        = string
}
variable "description" {
  description = "Description of what your Lambda Function does"
  type        = string
}
variable "default_root_object" {
  description = "Index file for cloudfront"
  default     = "index.html"
}
variable "origins" {
  description = "Add origins to cloud front"
  type = map(object({
    connection_attempts              = optional(number)
    connection_timeout               = optional(number)
    domain_name                      = string
    origin_path                      = optional(string)
    origin_access_control_id_enabled = optional(bool, false)
    s3_origin_config                 = optional(bool, false)
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
    }), null)
  }))
  default = {}
}
variable "viewer_certificate" {
  description = "Viewer certificate for cloudfront"
  type = object({
    cloudfront_default_certificate = optional(bool, true)
    acm_certificate_arn            = optional(string, null)
    ssl_support_method             = optional(string, null)
    minimum_protocol_version       = optional(string, "TLSv1.2_2019")
  })
  default = null
}
variable "default_cache_behavior" {
  description = "Default cache behavior for cloudfront"
  type = object({
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
}
variable "origin_access_controls" {
  description = "Origin access control for cloudfront"
  type = map(object({
    description                       = string
    signing_behavior                  = optional(string, "always")
    signing_protocol                  = optional(string, "sigv4")
    origin_access_control_origin_type = optional(string, "s3")
  }))
  default = {}
}
variable "tags" {
  description = "Map of tags to assign to the object."
  type        = map(string)
  default     = {}
}
