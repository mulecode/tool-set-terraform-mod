locals {
  enable_custom_domain_name = var.custom_domain == null ? false : true

  enable_base_path_mapping = try(var.custom_domain.base_path_mapping, false)

  custom_aliases = local.enable_custom_domain_name == true ? [var.custom_domain.domain_name] : []
}

resource "aws_api_gateway_domain_name" "main" {
  for_each = toset(local.enable_custom_domain_name ? ["singleton"] : [])

  domain_name              = var.custom_domain.domain_name
  regional_certificate_arn = var.custom_domain.acm_certificate_arn
  tags                     = local.tags

  endpoint_configuration {
    types = ["REGIONAL"]
  }

  security_policy = var.custom_domain.security_policy
  dynamic "mutual_tls_authentication" {
    for_each = toset(var.custom_domain.truststore_uri != null ? ["singleton"] : [])
    content {
      truststore_uri = var.custom_domain.truststore_uri
    }
  }
}

resource "aws_route53_record" "main" {
  for_each = toset(local.enable_custom_domain_name ? ["singleton"] : [])

  zone_id = var.custom_domain.zone_id
  name    = aws_api_gateway_domain_name.main["singleton"].domain_name
  type    = "A"

  alias {
    name                   = aws_api_gateway_domain_name.main["singleton"].regional_domain_name
    zone_id                = aws_api_gateway_domain_name.main["singleton"].regional_zone_id
    evaluate_target_health = true
  }
}

resource "aws_api_gateway_base_path_mapping" "main" {
  for_each = toset(local.enable_base_path_mapping ? ["singleton"] : [])

  api_id      = aws_api_gateway_rest_api.main.id
  domain_name = aws_api_gateway_domain_name.main["singleton"].domain_name
  stage_name  = aws_api_gateway_stage.main.stage_name
}
