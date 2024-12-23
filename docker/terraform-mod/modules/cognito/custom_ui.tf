locals {
  enable_custom_ui = var.custom_ui == null ? false : true
}

resource "aws_cognito_user_pool_ui_customization" "main" {
  for_each  = toset(local.enable_custom_ui ? ["singleton"] : [])
  client_id = aws_cognito_user_pool_client.main.id

  css        = file(var.custom_ui.css)
  image_file = filebase64(var.custom_ui.logo)

  # Refer to the aws_cognito_user_pool_domain resource's
  # user_pool_id attribute to ensure it is in an 'Active' state
  user_pool_id = aws_cognito_user_pool_domain.cognito_domain["singleton"].user_pool_id
}
