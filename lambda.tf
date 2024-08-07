provider "aws" {
  region = "us-east-1"
}

resource "aws_lambda_function" "friendcipes-core-lambda" {
  function_name = "friendcipes-core-lambda"
  s3_bucket = "friendcipes-lambda-source"
  s3_key    = "/${var.lambda_version}/friendcipes-core-lambda-1.0-SNAPSHOT.jar"
  handler = "com.friendcipes.FriendCipesCoreHandler::handleRequest"
  runtime = "java11"
  role = aws_iam_role.lambda_exec.arn
}

resource "aws_iam_role" "lambda_exec" {
  name = "friendcipes-core-lambda-exec"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "attachment_basic_execution" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
  role       = aws_iam_role.lambda_exec.name
}

resource "aws_iam_role_policy_attachment" "attachment_secrets_policy" {
  policy_arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
  role       = aws_iam_role.lambda_exec.name
}