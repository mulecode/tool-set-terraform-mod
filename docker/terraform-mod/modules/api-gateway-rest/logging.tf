locals {
  enable_logging = var.logging == null ? false : true
}

resource "aws_cloudwatch_log_group" "main" {
  for_each          = toset(local.enable_logging ? ["singleton"] : [])
  name              = "/aws/apigateway/${local.prefixed_name}/${aws_api_gateway_rest_api.main.id}/${var.stage_name}"
  retention_in_days = var.logging.retention_in_days
  tags              = local.tags
}
