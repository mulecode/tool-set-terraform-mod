output "id" {
  value = aws_cognito_user_pool_client.main.id
}

output "user_pool_id" {
  value = aws_cognito_user_pool_client.main.user_pool_id
}

output "user_pool_arn" {
  value = aws_cognito_user_pool.main.arn
}

output "user_pool_endpoint" {
  value = aws_cognito_user_pool.main.endpoint
}
