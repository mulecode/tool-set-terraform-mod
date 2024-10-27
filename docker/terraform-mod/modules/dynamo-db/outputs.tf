output "arn" {
  description = "DynamoDB table ARN"
  value       = aws_dynamodb_table.this.arn
}
output "id" {
  description = "DynamoDB table ID"
  value       = aws_dynamodb_table.this.id
}
output "name" {
  description = "DynamoDB table name"
  value       = aws_dynamodb_table.this.name
}
output "stream_arn" {
  description = "DynamicDB table stream ARN"
  value       = aws_dynamodb_table.this.stream_arn
}
output "stream_label" {
  description = "DynamicDB table stream label"
  value       = aws_dynamodb_table.this.stream_label
}
output "stream_view_type" {
  description = "DynamicDB table stream view type"
  value       = aws_dynamodb_table.this.stream_view_type
}
output "this" {
  description = "DynamoDB table"
  value       = aws_dynamodb_table.this
}

