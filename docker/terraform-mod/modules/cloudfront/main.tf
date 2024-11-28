locals {
  tags = merge(var.tags, {
    CreatedBy  = "terraform"
    ModuleName = "cloudfront"
  })
  prefixed_name = "${var.prefix}-${var.name}"
}

# Access Identity
resource "aws_cloudfront_origin_access_identity" "main" {
  comment = local.prefixed_name
}

resource "aws_cloudfront_origin_access_control" "main" {
  for_each                          = var.origin_access_controls
  name                              = "${local.prefixed_name}-${each.key}"
  description                       = each.value.description
  signing_behavior                  = each.value.signing_behavior
  signing_protocol                  = each.value.signing_protocol
  origin_access_control_origin_type = each.value.origin_access_control_origin_type
}

resource "aws_cloudfront_distribution" "main" {
  enabled             = true
  is_ipv6_enabled     = true
  comment             = var.description
  price_class         = "PriceClass_100"
  default_root_object = var.default_root_object

  dynamic "origin" {
    for_each = var.origins
    content {
      connection_attempts = origin.value.connection_attempts
      connection_timeout  = origin.value.connection_timeout
      origin_id           = origin.key
      domain_name         = origin.value.domain_name
      origin_path         = origin.value.origin_path
      origin_access_control_id = origin.value.origin_access_control_id_as_oai ? aws_cloudfront_origin_access_identity.main.id : (
        origin.value.origin_access_control_id_as_oac ? aws_cloudfront_origin_access_control.main[origin.key].id : origin.value.origin_access_control_id
      )

      dynamic "s3_origin_config" {
        # Legacy configuration
        for_each = origin.value.s3_origin_config ? ["singleton"] : []
        content {
          origin_access_identity = aws_cloudfront_origin_access_identity.main.cloudfront_access_identity_path
        }
      }

      dynamic "custom_origin_config" {
        for_each = origin.value.custom_origin_config != null ? [origin.value.custom_origin_config] : []
        content {
          http_port                = origin.value.custom_origin_config.http_port
          https_port               = origin.value.custom_origin_config.https_port
          origin_keepalive_timeout = origin.value.custom_origin_config.origin_keepalive_timeout
          origin_protocol_policy   = origin.value.custom_origin_config.origin_protocol_policy
          origin_read_timeout      = origin.value.custom_origin_config.origin_read_timeout
          origin_ssl_protocols     = origin.value.custom_origin_config.origin_ssl_protocols
        }
      }
    }
  }

  default_cache_behavior {
    allowed_methods  = var.default_cache_behavior.allowed_methods
    cached_methods   = var.default_cache_behavior.cached_methods
    target_origin_id = var.default_cache_behavior.target_origin_id

    forwarded_values {
      query_string = var.default_cache_behavior.forward_query_string

      cookies {
        forward = var.default_cache_behavior.forward_cookies
      }
    }

    viewer_protocol_policy = var.default_cache_behavior.viewer_protocol_policy
    min_ttl                = var.default_cache_behavior.min_ttl
    default_ttl            = var.default_cache_behavior.default_ttl
    max_ttl                = var.default_cache_behavior.max_ttl
  }

  dynamic "custom_error_response" {
    for_each = var.custom_error_responses
    content {
      error_code            = custom_error_response.value.error_code
      response_page_path    = custom_error_response.value.response_page_path
      response_code         = custom_error_response.value.response_code
      error_caching_min_ttl = custom_error_response.value.error_caching_min_ttl
    }
  }

  dynamic "viewer_certificate" {
    for_each = var.viewer_certificate != null && var.viewer_certificate.cloudfront_default_certificate ? [1] : []
    content {
      cloudfront_default_certificate = var.viewer_certificate.cloudfront_default_certificate
      acm_certificate_arn            = var.viewer_certificate.acm_certificate_arn
      ssl_support_method             = var.viewer_certificate.ssl_support_method
      minimum_protocol_version       = var.viewer_certificate.minimum_protocol_version
    }
  }

  dynamic "ordered_cache_behavior" {
    for_each = var.ordered_cache_behaviors
    content {
      path_pattern           = ordered_cache_behavior.value.path_pattern
      allowed_methods        = ordered_cache_behavior.value.allowed_methods
      cached_methods         = ordered_cache_behavior.value.cached_methods
      cache_policy_id        = ordered_cache_behavior.value.cache_policy_id
      target_origin_id       = ordered_cache_behavior.key
      viewer_protocol_policy = ordered_cache_behavior.value.viewer_protocol_policy

      dynamic "forwarded_values" {
        for_each = ordered_cache_behavior.value.forwarded_values != null ? ["singleton"] : []
        content {
          query_string = ordered_cache_behavior.value.forwarded_values.query_string

          dynamic "cookies" {
            for_each = ordered_cache_behavior.value.forwarded_values.cookies != null ? ["singleton"] : []
            content {
              forward = ordered_cache_behavior.value.forwarded_values.cookies.forward
            }
          }
        }
      }

      min_ttl     = ordered_cache_behavior.value.min_ttl
      default_ttl = ordered_cache_behavior.value.default_ttl
      max_ttl     = ordered_cache_behavior.value.max_ttl
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}
