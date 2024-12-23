locals {
  tags = merge(var.tags, {
    CreatedBy  = "terraform"
    ModuleName = "cognito-b2b"
  })

  enable_resource_server = var.resource_server == null ? false : true

  prefixed_name = "${var.prefix}-${var.name}"
}

resource "aws_cognito_user_pool" "main" {
  name = local.prefixed_name
  tags = local.tags

  dynamic "admin_create_user_config" {
    for_each = toset(var.admin_create_user_config != null ? ["singleton"] : [])
    content {
      allow_admin_create_user_only = var.admin_create_user_config.allow_admin_create_user_only
    }
  }
}

resource "aws_cognito_user_pool_client" "main" {
  name                                 = local.prefixed_name
  user_pool_id                         = aws_cognito_user_pool.main.id
  callback_urls                        = var.callback_urls
  allowed_oauth_flows_user_pool_client = var.allowed_oauth_flows_user_pool_client
  generate_secret                      = var.generate_client_secret
  allowed_oauth_flows                  = var.allowed_oauth_flows
  allowed_oauth_scopes                 = var.allowed_oauth_scopes
  supported_identity_providers         = ["COGNITO"]
}

resource "aws_cognito_resource_server" "main" {
  for_each   = toset(local.enable_resource_server ? ["singleton"] : [])
  identifier = var.resource_server.identifier
  name       = var.resource_server.name

  dynamic "scope" {
    for_each = { for key, value in var.resource_server.scopes : key => value }
    content {
      scope_name        = scope.value.scope_name
      scope_description = scope.value.description
    }
  }

  user_pool_id = aws_cognito_user_pool.main.id
}


