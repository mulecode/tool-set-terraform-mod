resource "aws_api_gateway_usage_plan" "main" {
  for_each     = var.quotas
  name         = "${local.prefixed_name}-plan"
  description  = var.description
  product_code = each.key
  tags         = local.tags

  api_stages {
    api_id = aws_api_gateway_rest_api.main.id
    stage  = aws_api_gateway_stage.main.stage_name
  }

  quota_settings {
    limit  = each.value.quota_limit
    offset = each.value.quota_offset
    period = each.value.quota_period
  }

  throttle_settings {
    burst_limit = each.value.throttle_burst_limit
    rate_limit  = each.value.throttle_rate_limit
  }
}

resource "aws_api_gateway_api_key" "main" {
  for_each = { for k, v in var.quotas : k => v if v.enable_api_key == true }
  name     = "${local.prefixed_name}-${each.key}-apikey"
  tags     = local.tags
}

resource "aws_api_gateway_usage_plan_key" "main" {
  for_each      = { for k, v in var.quotas : k => v if v.enable_api_key == true }
  key_id        = aws_api_gateway_api_key.main[each.key].id
  key_type      = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.main[each.key].id
}

resource "aws_secretsmanager_secret" "main" {
  for_each    = { for k, v in var.quotas : k => v if v.enable_api_key == true }
  name        = "${local.prefixed_name}-${each.key}-apikey"
  description = var.description
  tags        = var.tags
}

resource "aws_secretsmanager_secret_version" "main" {
  for_each      = { for k, v in var.quotas : k => v if v.enable_api_key == true }
  secret_id     = aws_secretsmanager_secret.main[each.key].id
  secret_string = aws_api_gateway_usage_plan_key.main[each.key].value
}
