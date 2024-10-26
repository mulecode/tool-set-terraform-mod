module "lambda" {
  source                = "./modules/lambda-function"
  for_each              = var.aws_lambda_functions
  prefix                = var.project_prefix
  name                  = each.key
  description           = each.value.description
  handler               = each.value.handler
  runtime               = each.value.runtime
  artefact_path         = each.value.artefact_path
  environment_variables = each.value.environment_variables
  role_arn              = each.value.role_arn
  permissions           = each.value.permissions
  layers                = each.value.layers
}
