locals {
  tags = merge(var.tags, {
    CreatedBy  = "terraform"
    ModuleName = "api-gateway-public"
  })

  prefixed_name = "${var.prefix}-${var.name}"
}

resource "aws_api_gateway_rest_api" "main" {
  name = local.prefixed_name
  body = var.api_body

  put_rest_api_mode            = "merge"
  disable_execute_api_endpoint = var.disable_execute_api_endpoint

  endpoint_configuration {
    types = ["REGIONAL"]
  }

  tags = local.tags
}

resource "aws_api_gateway_deployment" "main" {
  rest_api_id = aws_api_gateway_rest_api.main.id

  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.main.body))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "main" {
  deployment_id = aws_api_gateway_deployment.main.id
  rest_api_id   = aws_api_gateway_rest_api.main.id
  stage_name    = var.stage_name
  tags          = local.tags

  dynamic "access_log_settings" {
    for_each = toset(local.enable_logging ? ["singleton"] : [])
    content {
      destination_arn = aws_cloudwatch_log_group.main["singleton"].arn

      format = jsonencode({
        "requestId" : "$context.requestId",
        "ip" : "$context.identity.sourceIp",
        "caller" : "$context.identity.caller",
        "user" : "$context.identity.user",
        "requestTime" : "$context.requestTime",
        "httpMethod" : "$context.httpMethod",
        "resourcePath" : "$context.resourcePath",
        "status" : "$context.status",
        "protocol" : "$context.protocol",
        "responseLength" : "$context.responseLength",
        "integrationErrorMessage" : "$context.integrationErrorMessage"
      })
    }
  }
}
