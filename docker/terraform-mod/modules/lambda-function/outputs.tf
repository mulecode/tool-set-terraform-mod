output "lambda_id" {
  value = aws_lambda_function.main.id
}

output "lambda_arn" {
  value = aws_lambda_function.main.arn
}

output "qualified_arn" {
  value = aws_lambda_function.main.qualified_arn
}

output "invoke_arn" {
  value = aws_lambda_function.main.invoke_arn
}

output "lambda_function_name" {
  value = aws_lambda_function.main.function_name
}

output "lambda_function_version" {
  value = aws_lambda_function.main.version
}

