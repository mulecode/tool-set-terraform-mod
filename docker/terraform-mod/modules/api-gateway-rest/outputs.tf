output "execution_arn" {
  value = aws_api_gateway_deployment.main.execution_arn
}

output "rest_api_id" {
  value = aws_api_gateway_rest_api.main.id
}

output "invoke_url" {
  value = aws_api_gateway_deployment.main.invoke_url
}

output "api_url" {
  value = "${aws_api_gateway_deployment.main.invoke_url}${aws_api_gateway_stage.main.stage_name}"
}

output "api_stage" {
  value = aws_api_gateway_stage.main.stage_name
}

output "api_stage_arn" {
  value = aws_api_gateway_stage.main.arn
}

output "api_stage_id" {
  value = aws_api_gateway_stage.main.id
}
