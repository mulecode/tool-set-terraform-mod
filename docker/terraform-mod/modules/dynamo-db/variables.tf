variable "prefix" {
  description = "Prefix for the Role resource"
  type        = string
}
variable "name" {
  description = "DynamoDB table name"
  type        = string
}
variable "billing_mode" {
  description = "DynamoDB table billing mode"
  type        = string
  default     = "PAY_PER_REQUEST"
}
variable "hash_key" {
  description = "DynamoDB table hash key"
  type        = string
}
variable "range_key" {
  description = "DynamoDB table range key"
  type        = string
  default     = null
}
variable "read_capacity" {
  description = "DynamoDB table read capacity"
  type        = number
  default     = null
}
variable "write_capacity" {
  description = "DynamoDB table write capacity"
  type        = number
  default     = null
}
variable "stream_enabled" {
  description = "DynamoDB table stream enabled flag"
  type        = bool
  default     = false
}
variable "stream_view_type" {
  description = "DynamoDB table stream view type"
  type        = string
  default     = null
}
variable "tags" {
  description = "Map of tags to assign to the object."
  type        = map(string)
  default     = {}
}
variable "attribute" {
  description = "Map of attributes to assign to the object."
  type = set(object({
    name = string
    type = string
  }))
}
variable "global_secondary_index" {
  description = "DynamoDb table global secondary index"
  type = set(object({
    hash_key           = string
    name               = string
    non_key_attributes = optional(list(string), null)
    projection_type    = string
    range_key          = optional(string, null)
    read_capacity      = optional(number, null)
    write_capacity     = optional(number, null)
  }))
  default = []
}
variable "local_secondary_index" {
  description = "DynamoDb table local secondary index"
  type = set(object({
    name               = string
    non_key_attributes = list(string)
    projection_type    = string
    range_key          = string
  }))
  default = []
}
variable "point_in_time_recovery" {
  description = "Whether to enable point-in-time recovery"
  type = set(object({
    enabled = bool
  }))
  default = [{ "enabled" = false }]
}
variable "replica" {
  description = "Whether to enable Point In Time Recovery for the replica"
  type = set(object({
    region_name = string
  }))
  default = []
}
variable "timeouts" {
  description = "nested mode: NestingSingle, min items: 0, max items: 0"
  type = set(object({
    create = string
    delete = string
    update = string
  }))
  default = []
}
variable "ttl" {
  description = "Whether TTL is enabled"
  type = set(object({
    attribute_name = string
    enabled        = bool
  }))
  default = []
}




