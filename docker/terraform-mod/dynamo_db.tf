module "aws_dynamodb_table" {
  for_each = var.aws_dynamodb_tables
  source   = "./modules/dynamo-db"

  prefix           = var.project_prefix
  name             = each.key
  billing_mode     = each.value.billing_mode
  hash_key         = each.value.hash_key
  range_key        = each.value.range_key
  read_capacity    = each.value.read_capacity
  write_capacity   = each.value.write_capacity
  stream_enabled   = each.value.stream_enabled
  stream_view_type = each.value.stream_view_type
  tags             = each.value.tags
  attribute        = each.value.attribute

  global_secondary_index = each.value.global_secondary_index
  local_secondary_index  = each.value.local_secondary_index
  timeouts               = each.value.timeouts
  ttl                    = each.value.ttl
}
