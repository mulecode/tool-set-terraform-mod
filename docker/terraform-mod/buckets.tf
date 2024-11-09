module "bucket" {
  source     = "./modules/bucket"
  for_each   = var.aws_s3_buckets
  prefix     = var.project_prefix
  name       = each.key
  versioning = each.value.versioning
  acl        = each.value.acl
}

module "bucket_policy" {
  source    = "./modules/bucket-policy"
  for_each  = var.aws_s3_bucket_policies
  bucket_id = module.bucket[each.key].bucket_id
  policy    = templatefile(each.value.policy, each.value.policy_vars)
}
