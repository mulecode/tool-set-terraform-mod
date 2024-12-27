module "cognito" {
  source   = "./modules/cognito"
  for_each = var.aws_cognito_configs

  prefix      = var.project_prefix
  name        = each.key
  description = each.value.description

  allowed_oauth_flows_user_pool_client = each.value.allowed_oauth_flows_user_pool_client
  generate_client_secret               = each.value.generate_client_secret
  allowed_oauth_flows                  = each.value.allowed_oauth_flows
  allowed_oauth_scopes                 = each.value.allowed_oauth_scopes
  cognito_domain                       = try(each.value.cognito_domain, null)
  custom_domain                        = each.value.custom_domain
  callback_urls                        = try(each.value.callback_urls, null)
  resource_server                      = each.value.resource_server
  admin_create_user_config             = try(each.value.admin_create_user_config, null)
  custom_ui                            = try(each.value.custom_ui, null)
  schemas                              = each.value.schemas
  tags                                 = each.value.tags
}
