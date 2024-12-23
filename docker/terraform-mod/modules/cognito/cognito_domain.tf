locals {
  enable_cognito_domain = var.cognito_domain == null ? false : true
}

resource "aws_cognito_user_pool_domain" "cognito_domain" {
  for_each     = toset(local.enable_cognito_domain ? ["singleton"] : [])
  domain       = var.cognito_domain.domain
  user_pool_id = aws_cognito_user_pool.main.id
}
