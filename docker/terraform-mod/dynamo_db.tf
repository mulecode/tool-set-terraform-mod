module "aws_dynamodb_table" {
  for_each = var.aws_dynamodb_tables
  source   = "./modules/dynamo-db"

  prefix = var.project_prefix
  name                   = each.key
  billing_mode           = each.value.billing_mode
  hash_key               = each.value.hash_key
  attribute              = each.value.attribute
  global_secondary_index = each.value.global_secondary_index
  ttl                    = each.value.ttl
}
