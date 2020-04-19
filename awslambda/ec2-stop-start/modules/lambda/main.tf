variable "lambda_role_arn" {
  description = "The ARN of the IAM role to be attached to the Lambda function."
}

resource "aws_lambda_function" "lambda_func" {
  function_name = "lambda_func"
  filename      = "${path.module}/code/ec2-start-stop.zip"
  role          = var.lambda_role_arn  # Use the input variable here
  handler       = "ec2-start-stop.lambda_handler"
  runtime       = "python3.8"
}

resource "aws_lambda_function_url" "function" {
  function_name      = aws_lambda_function.lambda_func.arn
  authorization_type = "NONE"
}
