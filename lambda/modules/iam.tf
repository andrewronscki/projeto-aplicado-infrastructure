data "aws_iam_policy_document" "lambda-assume-role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "test_lambda" {
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "lambda:InvokeFunction",
      "s3:*"
      # "kms:Decrypt",
      # "sqs:*"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_role" "test_lambda" {
  name               = "test-lambda-${var.env}"
  assume_role_policy = data.aws_iam_policy_document.lambda-assume-role.json
}

resource "aws_iam_policy" "test_lambda" {
  name   = "${aws_lambda_function.test_lambda.function_name}-execute-policy-${var.env}"
  policy = data.aws_iam_policy_document.test_lambda.json
}

resource "aws_iam_role_policy_attachment" "s3-execute" {
  policy_arn = aws_iam_policy.test_lambda.arn
  role       = aws_iam_role.test_lambda.name
}
