
output "db_address" {
  value       = aws_db_instance.friendcipesdb.address
  description = "Address of RDS instance"
}

output "api_gw_base_url" {
  value = aws_api_gateway_deployment.friendcipes-core-api.invoke_url
}