module "aws_api_gateway_rest" {
  source                       = "./modules/api-gateway-rest"
  for_each                     = var.aws_api_gateways
  prefix                       = var.project_prefix
  name                         = each.key
  description                  = each.value.description
  disable_execute_api_endpoint = each.value.disable_execute_api_endpoint
  api_body                     = templatefile(each.value.api_body, each.value.api_body_params)
  custom_domain                = try(each.value.custom_domain, null)
  quota                        = each.value.quota
}
