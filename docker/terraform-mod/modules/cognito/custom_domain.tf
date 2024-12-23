locals {
  enable_custom_domain = var.custom_domain == null ? false : true
}

resource "aws_cognito_user_pool_domain" "custom_domain" {
  for_each        = toset(local.enable_custom_domain ? ["singleton"] : [])
  domain          = var.custom_domain.domain
  certificate_arn = var.custom_domain.certificate_arn
  user_pool_id    = aws_cognito_user_pool.main.id
}

resource "aws_route53_record" "custom_domain" {
  for_each = toset(local.enable_custom_domain ? ["singleton"] : [])
  name     = aws_cognito_user_pool_domain.custom_domain["singleton"].domain
  type     = "A"
  zone_id  = var.custom_domain.zone_id
  alias {
    evaluate_target_health = false
    name                   = aws_cognito_user_pool_domain.custom_domain["singleton"].cloudfront_distribution_arn
    # This zone_id is fixed
    zone_id = "Z2FDTNDATAQYW2"
  }
}
