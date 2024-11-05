resource "aws_s3_bucket_policy" "main" {
  bucket = var.bucket_id
  policy = templatefile(var.policy, var.policy_vars)
}
