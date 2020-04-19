resource "aws_iam_role" "lambda_role" {
  name = "Spacelift_Test_Lambda_Function_Role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Principal = {
          Service = "lambda.amazonaws.com"
        },
        Effect = "Allow",
        Sid = ""
      }
    ]
  })
}

resource "aws_iam_policy" "iam_policy_for_lambda" {
  name        = "aws_iam_policy_for_terraform_aws_lambda_role"
  path        = "/"
  description = "AWS IAM Policy for managing aws lambda role"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action   = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "arn:aws:logs:*:*:*",
        Effect   = "Allow"
      },
      {
        Effect = "Allow",
        Action = [
          "ec2:Start*",
          "ec2:Stop*",
          "ec2:DescribeInstances"
        ],
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_iam_policy_to_iam_role" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.iam_policy_for_lambda.arn
}


output "lambda_role_arn" {
  value = aws_iam_role.lambda_role.arn
}
