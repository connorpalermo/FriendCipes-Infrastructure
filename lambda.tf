provider "aws" {
  region = "us-east-1"
}

resource "aws_lambda_function" "friendcipes-core-lambda" {
  function_name = "friendcipes-core-lambda"

  # The bucket name as created earlier with "aws s3api create-bucket"
  s3_bucket = "friendcipes-lambda-source"
  s3_key    = "friendcipes-core-lambda-1.0-SNAPSHOT.jar"

  # "main" is the filename within the zip file (main.js) and "handler"
  # is the name of the property under which the handler function was
  # exported in that file.
  handler = "com.friendcipes.FriendCipesCoreHandler::handleRequest"
  runtime = "java8"

  role = "${aws_iam_role.lambda_exec.arn}"
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