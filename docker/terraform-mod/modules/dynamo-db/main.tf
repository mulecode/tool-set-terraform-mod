locals {
  tags = merge(var.tags, {
    CreatedBy  = "terraform"
    ModuleName = "dynamo-db"
  })
  prefixed_name = "${var.prefix}-${var.name}"
}

resource "aws_dynamodb_table" "this" {
  name             = local.prefixed_name
  billing_mode     = var.billing_mode
  hash_key         = var.hash_key
  range_key        = var.range_key
  read_capacity    = var.read_capacity
  write_capacity   = var.write_capacity
  stream_enabled   = var.stream_enabled
  stream_view_type = var.stream_view_type
  tags             = local.tags


  dynamic "attribute" {
    for_each = var.attribute
    content {
      name = attribute.value["name"]
      type = attribute.value["type"]
    }
  }

  dynamic "global_secondary_index" {
    for_each = var.global_secondary_index
    content {
      hash_key           = global_secondary_index.value["hash_key"]
      name               = global_secondary_index.value["name"]
      non_key_attributes = global_secondary_index.value["non_key_attributes"]
      projection_type    = global_secondary_index.value["projection_type"]
      range_key          = global_secondary_index.value["range_key"]
      read_capacity      = global_secondary_index.value["read_capacity"]
      write_capacity     = global_secondary_index.value["write_capacity"]
    }
  }

  dynamic "local_secondary_index" {
    for_each = var.local_secondary_index
    content {
      name               = local_secondary_index.value["name"]
      non_key_attributes = local_secondary_index.value["non_key_attributes"]
      projection_type    = local_secondary_index.value["projection_type"]
      range_key          = local_secondary_index.value["range_key"]
    }
  }

  dynamic "point_in_time_recovery" {
    for_each = var.point_in_time_recovery
    content {
      enabled = point_in_time_recovery.value["enabled"]
    }
  }

  dynamic "replica" {
    for_each = var.replica
    content {
      region_name = replica.value["region_name"]
    }
  }

  dynamic "timeouts" {
    for_each = var.timeouts
    content {
      create = timeouts.value["create"]
      delete = timeouts.value["delete"]
      update = timeouts.value["update"]
    }
  }

  dynamic "ttl" {
    for_each = var.ttl
    content {
      attribute_name = ttl.value["attribute_name"]
      enabled        = ttl.value["enabled"]
    }
  }

}
