resource "aws_lambda_permission" "main" {
  for_each = { for item in var.permissions : item.statement_id => item }

  statement_id  = "${var.prefix}-${each.key}"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.main.function_name
  principal     = each.value.principal
  source_arn    = each.value.source_arn
}
