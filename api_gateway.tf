resource "aws_api_gateway_rest_api" "friendcipes-core-api" {
  name        = "FriendCipes-Core-API"
  description = "Core API Endpoints for FriendCipes"
}

resource "aws_api_gateway_resource" "friendcipes-proxy" {
  rest_api_id = aws_api_gateway_rest_api.friendcipes-core-api.id
  parent_id   = aws_api_gateway_rest_api.friendcipes-core-api.id
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "proxy" {
  rest_api_id   = aws_api_gateway_rest_api.friendcipes-core-api.id
  resource_id   = aws_api_gateway_resource.friendcipes-proxy.id
  http_method   = "ANY"
  authorization = "NONE"
  depends_on = [aws_api_gateway_resource.friendcipes-proxy]
}

resource "aws_api_gateway_integration" "lambda" {
  rest_api_id = aws_api_gateway_rest_api.friendcipes-core-api.id
  resource_id = aws_api_gateway_method.proxy.resource_id
  http_method = aws_api_gateway_method.proxy.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.friendcipes-core-lambda.invoke_arn
}

resource "aws_api_gateway_method" "proxy_root" {
  rest_api_id   = aws_api_gateway_rest_api.friendcipes-core-api.id
  resource_id   = aws_api_gateway_rest_api.friendcipes-core-api.root_resource_id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_root" {
  rest_api_id = aws_api_gateway_rest_api.friendcipes-core-api.id
  resource_id = aws_api_gateway_method.proxy_root.resource_id
  http_method = aws_api_gateway_method.proxy_root.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.friendcipes-core-lambda.invoke_arn
}

resource "aws_api_gateway_deployment" "friendcipes-core-api" {
  depends_on = [
    aws_api_gateway_integration.lambda,
    aws_api_gateway_integration.lambda_root,
  ]

  rest_api_id = aws_api_gateway_rest_api.friendcipes-core-api.id
  stage_name  = "test"
}