resource "aws_cloudwatch_log_group" "main" {
  name              = local.cloudwatch_log_group_name
  retention_in_days = 7
  tags              = local.tags
}
