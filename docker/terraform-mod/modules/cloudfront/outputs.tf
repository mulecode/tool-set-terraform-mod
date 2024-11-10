output "origin_access_identity_arn" {
  value = aws_cloudfront_origin_access_identity.main.iam_arn
}
