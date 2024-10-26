locals {
  tags = merge(var.tags, {
    CreatedBy  = "terraform"
    ModuleName = "lambda-function"
  })

  prefixed_name             = "${var.prefix}-${var.name}"
  cloudwatch_log_group_name = "/aws/lambda/${local.prefixed_name}"
}

resource "aws_lambda_function" "main" {
  function_name                  = local.prefixed_name
  description                    = var.description
  role                           = var.role_arn
  filename                       = var.artefact_path
  source_code_hash               = filebase64sha256(var.artefact_path)
  runtime                        = var.runtime
  handler                        = var.handler
  timeout                        = var.timeout_seconds
  memory_size                    = var.memory_size
  reserved_concurrent_executions = var.concurrent_executions
  publish                        = var.publish
  layers                         = var.layers
  tags                           = local.tags

  environment {
    variables = var.environment_variables
  }

  tracing_config {
    mode = var.tracing_mode
  }

  depends_on = [
    aws_cloudwatch_log_group.main
  ]
}
