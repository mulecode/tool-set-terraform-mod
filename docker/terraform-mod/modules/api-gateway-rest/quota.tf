locals {
  enable_quota = var.quota == null ? false : true

  enable_api_key = local.enable_quota ? try(var.quota.enable_api_key, false) : false
}

resource "aws_api_gateway_usage_plan" "main" {
  for_each     = toset(local.enable_quota ? ["singleton"] : [])
  name         = "${local.prefixed_name}-plan"
  description  = var.description
  product_code = var.quota.product_code
  tags         = local.tags

  api_stages {
    api_id = aws_api_gateway_rest_api.main.id
    stage  = aws_api_gateway_stage.main.stage_name
  }

  quota_settings {
    limit  = var.quota.quota_limit
    offset = var.quota.quota_offset
    period = var.quota.quota_period
  }

  throttle_settings {
    burst_limit = var.quota.throttle_burst_limit
    rate_limit  = var.quota.throttle_rate_limit
  }
}

resource "aws_api_gateway_api_key" "main" {
  for_each = toset(local.enable_api_key ? ["singleton"] : [])
  name     = "${local.prefixed_name}-apikey"
  tags     = local.tags
}

resource "aws_api_gateway_usage_plan_key" "main" {
  for_each      = toset(local.enable_api_key ? ["singleton"] : [])
  key_id        = aws_api_gateway_api_key.main["singleton"].id
  key_type      = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.main["singleton"].id
}

resource "aws_secretsmanager_secret" "main" {
  for_each    = toset(local.enable_api_key ? ["singleton"] : [])
  name        = "${local.prefixed_name}-apikey"
  description = var.description
  tags        = var.tags
}

resource "aws_secretsmanager_secret_version" "main" {
  for_each      = toset(local.enable_api_key ? ["singleton"] : [])
  secret_id     = aws_secretsmanager_secret.main["singleton"].id
  secret_string = aws_api_gateway_usage_plan_key.main["singleton"].value
}
