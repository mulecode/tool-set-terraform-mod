module "cloudfront" {
  source   = "./modules/cloudfront"
  for_each = var.aws_cloudfront_distributions

  prefix                 = var.project_prefix
  name                   = each.key
  description            = each.value.description
  default_root_object    = each.value.default_root_object
  origins                = each.value.origins
  viewer_certificate     = each.value.viewer_certificate
  default_cache_behavior = each.value.default_cache_behavior
  origin_access_controls = each.value.origin_access_controls

  tags = each.value.tags
}
