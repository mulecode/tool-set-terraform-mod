locals {
  enable_secret_id = contains(var.allowed_oauth_flows, "client_credentials") ? true : false
}

resource "aws_secretsmanager_secret" "client_id" {
  name        = "${local.prefixed_name}-clientId"
  description = var.description
  tags        = var.tags
}

resource "aws_secretsmanager_secret_version" "client_id" {
  secret_id     = aws_secretsmanager_secret.client_id.id
  secret_string = aws_cognito_user_pool_client.main.id
}

resource "aws_secretsmanager_secret" "secret_key" {
  for_each    = toset(local.enable_secret_id ? ["singleton"] : [])
  name        = "${local.prefixed_name}-secretKey"
  description = var.description
  tags        = var.tags
}

resource "aws_secretsmanager_secret_version" "secret_key" {
  for_each      = toset(local.enable_secret_id ? ["singleton"] : [])
  secret_id     = aws_secretsmanager_secret.secret_key["singleton"].id
  secret_string = aws_cognito_user_pool_client.main.client_secret
}
