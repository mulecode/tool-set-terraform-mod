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
  # origin_bucket = {
  #   origin_id   = "S3WebsiteBucket"
  #   domain_name = module.bucket["fortify-guard-cdn"].bucket_regional_domain_name
  #   bucket_id   = module.bucket["fortify-guard-cdn"].bucket_id
  #   bucket_arn  = module.bucket["fortify-guard-cdn"].bucket_arn
  # }
  #   origin_bucket_website = {
  #     origin_id   = "S3WebsiteBucket"
  #     origin_path = "/index.html"
  #     domain_name = "fortify-guard-cdn-901872380504.s3-website.eu-west-2.amazonaws.com"
  #   }

  #   origin_apigw = {
  #     domain_name = replace(module.api_gateway.invoke_url, "/^https?://([^/]*).*/", "$1")
  #     origin_path = "/api"
  #   }

  # custom_domain = {
  #   domain_name         = "${var.cf_custom_domain}.${var.domain_name}"
  #   zone_id             = data.aws_route53_zone.selected.zone_id
  #   acm_certificate_arn = data.aws_acm_certificate.global.arn
  # }
}
